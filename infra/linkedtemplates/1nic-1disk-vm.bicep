@description('Computer Name')
param computerName string

@description('Computer IP Address')
param computerIP string

@description('Image Publisher')
param Publisher string

@description('Image Publisher Offer')
param Offer string

@description('OS Version')
param OSVersion string

@description('License Type (Windows_Server or None)')
param LicenseType string

@description('VMSize')
param VMSize string

@description('Existing VNET Name that contains the domain controller')
param vnetName string

@description('Existing subnet name that contains the domain controller')
param subnetName string

@description('VNet IP Prefix')
param vnetPrefix string

@description('Subnet IP Prefix')
param subnetPrefix string

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('Region of Resources')
param location string

var storageAccountType = 'Premium_LRS'
var VMName = computerName
var imagePublisher = Publisher
var imageOffer = Offer
var imageSKU = OSVersion
var subnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
var virtualNetworkAddressRange = vnetPrefix
var NicName = '${computerName}-nic'
var NicIPAddress = computerIP

resource Nic 'Microsoft.Network/networkInterfaces@2018-11-01' = {
  name: NicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: NicIPAddress
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}

resource VM 'Microsoft.Compute/virtualMachines@2019-03-01' = {
  name: VMName
  location: location
  properties: {
    licenseType: LicenseType
    hardwareProfile: {
      vmSize: VMSize
    }
    osProfile: {
      computerName: VMName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSKU
        version: 'latest'
      }
      osDisk: {
        name: '${VMName}_OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: storageAccountType
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: Nic.id
        }
      ]
    }
  }
}

param computerName string
param LicenseType string
param SQLLicenseType string
param AvailabilitySetName string
param enableAcceleratedNetworking bool = true
param PrivateIP string
param PublicIP string
param subnet1Name string
param subnet2Name string

@description('Existing VNET Name that contains the domain controller')
param vnetName string
param osDiskType string
param dataDisks array
param dataDiskResources array
param VMSize string
param adminUsername string

@secure()
param adminPassword string
param sqlConnectivityType string
param sqlPortNumber int
param sqlStorageWorkloadType string
param sqlStorageDisksConfigurationType string
param sqlAutopatchingDayOfWeek string
param sqlAutopatchingStartHour string
param sqlAutopatchingWindowDuration string
param dataPath string
param dataDisksLUNs array
param logPath string
param logDisksLUNs array
param tempDbPath string
param rServicesEnabled string
param location string

var subnetId1 = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnet1Name)
var subnetId2 = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnet2Name)
var NicName1 = '${computerName}-priv'
var NicName2 = '${computerName}-pub'
var NicIPAddress1 = PrivateIP
var NicIPAddress2 = PublicIP

resource Nic1 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: NicName1
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: NicIPAddress1
          subnet: {
            id: subnetId1
          }
        }
      }
    ]
    enableAcceleratedNetworking: enableAcceleratedNetworking
  }
}

resource Nic2 'Microsoft.Network/networkInterfaces@2018-10-01' = {
  name: NicName2
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: NicIPAddress2
          subnet: {
            id: subnetId2
          }
        }
      }
    ]
    enableAcceleratedNetworking: enableAcceleratedNetworking
  }
}

resource dataDiskResources_name 'Microsoft.Compute/disks@2020-05-01' = [
  for item in dataDiskResources: {
    name: item.name
    location: location
    properties: item.properties
    sku: {
      name: item.sku
    }
  }
]

resource computer 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: computerName
  location: location
  properties: {
    availabilitySet: {
      id: resourceId('Microsoft.Compute/availabilitySets', AvailabilitySetName)
    }
    hardwareProfile: {
      vmSize: VMSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
      imageReference: {
        publisher: 'microsoftsqlserver'
        offer: 'sql2019-ws2019'
        sku: 'enterprise'
        version: 'latest'
      }
      dataDisks: [
        for item in dataDisks: {
          lun: item.lun
          createOption: item.createOption
          caching: item.caching
          diskSizeGB: item.diskSizeGB
          managedDisk: {
            id: (item.id ?? ((item.name == json('null'))
              ? json('null')
              : resourceId('Microsoft.Compute/disks', item.name)))
            storageAccountType: item.storageAccountType
          }
          writeAcceleratorEnabled: item.writeAcceleratorEnabled
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: Nic1.id
        }
        {
          properties: {
            primary: false
          }
          id: Nic2.id
        }
      ]
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
      }
    }
    licenseType: LicenseType
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
  dependsOn: [
    dataDiskResources_name
  ]
}

resource Microsoft_SqlVirtualMachine_SqlVirtualMachines_computer 'Microsoft.SqlVirtualMachine/SqlVirtualMachines@2017-03-01-preview' = {
  name: computerName
  location: location
  properties: {
    virtualMachineResourceId: computer.id
    sqlManagement: 'Full'
    sqlServerLicenseType: SQLLicenseType
    autoPatchingSettings: {
      enable: true
      dayOfWeek: sqlAutopatchingDayOfWeek
      maintenanceWindowStartingHour: sqlAutopatchingStartHour
      maintenanceWindowDuration: sqlAutopatchingWindowDuration
    }
    keyVaultCredentialSettings: {
      enable: false
      credentialName: ''
    }
    storageConfigurationSettings: {
      diskConfigurationType: sqlStorageDisksConfigurationType
      storageWorkloadType: sqlStorageWorkloadType
      sqlDataSettings: {
        luns: dataDisksLUNs
        defaultFilePath: dataPath
      }
      sqlLogSettings: {
        luns: logDisksLUNs
        defaultFilePath: logPath
      }
      sqlTempDbSettings: {
        defaultFilePath: tempDbPath
      }
    }
    serverConfigurationsManagementSettings: {
      sqlConnectivityUpdateSettings: {
        connectivityType: sqlConnectivityType
        port: sqlPortNumber
        sqlAuthUpdateUserName: ''
        sqlAuthUpdatePassword: ''
      }
      additionalFeaturesServerConfigurations: {
        isRServicesEnabled: rServicesEnabled
      }
    }
  }
}

output adminUsername string = adminUsername

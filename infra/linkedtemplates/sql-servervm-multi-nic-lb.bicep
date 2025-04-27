param computerName string
param LoadBalancerName string
param enableAcceleratedNetworking bool = true

@description('Existing VNET Name that contains the domain controller')
param vnetName string
param subnetName string
param PublicIP string
param location string

var subnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
var NicName = '${computerName}-pub'
var NicIPAddress = PublicIP

resource Nic 'Microsoft.Network/networkInterfaces@2018-10-01' = {
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
          loadBalancerBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', LoadBalancerName, 'SQLServers')
            }
          ]
        }
      }
    ]
    enableAcceleratedNetworking: enableAcceleratedNetworking
  }
}

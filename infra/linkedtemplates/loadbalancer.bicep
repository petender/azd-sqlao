@description('Name of Load Balancer')
param LoadBalancerName string

@description('SQL Access Point Name')
param SQLAPName string

@description('SQL Access Point IP')
param SQLAPIP string

@description('Existing VNET Name that contains the domain controller')
param vnetName string
param subnetName string

@description('Set SKU Type to either Basic or Standard')
param Sku string

@description('Specifies the location of creation')
param location string

var subnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource LoadBalancer 'Microsoft.Network/loadBalancers@2020-05-01' = {
  name: LoadBalancerName
  location: location
  sku: {
    name: Sku
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: SQLAPName
        properties: {
          privateIPAddress: SQLAPIP
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: subnetId
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'SQLServers'
        properties: {}
      }
    ]
    loadBalancingRules: [
      {
        name: 'SQLAlwaysOnEndPointListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', LoadBalancerName, SQLAPName)
          }
          frontendPort: 1433
          backendPort: 1433
          enableFloatingIP: true
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
          loadDistribution: 'Default'
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', LoadBalancerName, 'SQLServers')
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', LoadBalancerName, 'SQLAlwaysOnEndPointProbe')
          }
        }
      }
    ]
    probes: [
      {
        name: 'SQLAlwaysOnEndPointProbe'
        properties: {
          protocol: 'Tcp'
          port: 59999
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    inboundNatRules: []
    inboundNatPools: []
  }
}

// Remove this resource as backendAddressPools are already defined within the LoadBalancer resource


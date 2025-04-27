@description('Name of Availability Set')
param AvailabilitySetName string

@description('Number of Update Domains')
param UpdateDomainCount int

@description('Number of Fault Domains')
param FaultDomainCount int

@description('Set SKU Type to either Aligned or Classic')
param Sku string

@description('Specifies the location of creation')
param location string

resource AvailabilitySet 'Microsoft.Compute/availabilitySets@2018-10-01' = {
  name: AvailabilitySetName
  location: location
  properties: {
    platformUpdateDomainCount: UpdateDomainCount
    platformFaultDomainCount: FaultDomainCount
  }
  sku: {
    name: Sku
  }
}

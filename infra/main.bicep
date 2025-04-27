targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param _artifactsLocation string = 'https://github.com/petender/azd-sqlao/blob/main/infra/'

@description('Auto-generated token to access _artifactsLocation')
@secure()
param _artifactsLocationSasToken string = ''

// Tags that should be applied to all resources.
// 
// Note that 'azd-service-name' tags should be applied separately to service host resources.
// Example usage:
//   tags: union(tags, { 'azd-service-name': <service name in azure.yaml> })
var tags = {
  'azd-env-name': environmentName
}

// This deploys the Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

// Add resources to be provisioned below. This can be actual resources, or if you follow the modular approach, create a module and point to the module.bicep file, like this example:
module sqlao 'sqlao.bicep' = {
  name: 'resources'
  scope: rg
  params: {
    adminUsername: 'adminuser'
    adminPassword : 'P@ssw0rd!'
    WindowsLicenseType : 'None'
    SQLLicenseType : 'AHUB'
    AvailabilitySetName : 'MTT-SQL-AVS'
    LoadBalancerName : 'MTT-SQL-LB'
    ServiceAccount: 'SQLSvc'
    InstallAccount : 'Install'
    OSDiskType : 'Premium_LRS'
    SqlClusterName : 'MTT-SQL-Cluster'
    SQLAGName : 'MTT-AG'
    SQLAPName : 'MTT-AP'
    SQLNode1 : '01'
    SQLNode2 : '02'
    SQLLastAPOctet : '10'
    SQL1LastPrivOctet : '11'
    SQL2LastPrivOctet : '12'
    SQL1LastPubOctet : '11'
    SQL2LastPubOctet : '12'
    SQL1DGLastPubOctet : '1'
    SQL2DGLastPubOctet : '1'
    NamingConvention : 'mtt'
    StorageAccountPrefix : 'mtt'
    SubDNSDomain : ''
    SubDNSBaseDN : ''
    NetBiosDomain : 'mttdemodomain'
    InternalDomain : 'mttdemodomain'
    InternalTLD : 'com'
    VNet1ID : '10.1'
    ReverseLookup1param : '1.10'
    DC1OSVersion : '2019-Datacenter'
    ToolOSVersion : '2019-Datacenter'
    DC1VMSize : 'Standard_D2s_v3'
    ToolVMSize : 'Standard_D2s_v3'
    SQLVMSize : 'Standard_D8s_v3'
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken


  }
}

// Add outputs from the deployment here, if needed.
//
// This allows the outputs to be referenced by other bicep deployments in the deployment pipeline,
// or by the local machine as a way to reference created resources in Azure for local development.
// Secrets should not be added here.
//
// Outputs are automatically saved in the local azd environment .env file.
// To see these outputs, run `azd env get-values`,  or `azd env get-values --output json` for json output.
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId

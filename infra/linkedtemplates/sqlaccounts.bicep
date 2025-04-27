@description('Computer Name')
param computerName string

@description('Base Domain Distiguished Name')
param BaseDN string

@description('Domain Name')
param DomainName string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Service Account')
param ServiceAccount string

@description('Install Account')
param InstallAccount string

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('Region of Resources')
param location string

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param _artifactsLocation string 
@description('Auto-generated token to access _artifactsLocation')
@secure()
param _artifactsLocationSasToken string

var ModulesURL = uri(_artifactsLocation, '/DSC/SQLACCOUNTS.zip${_artifactsLocationSasToken}')
var ConfigurationFunction = 'SQLACCOUNTS.ps1\\SQLACCOUNTS'

resource computerName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: '${_artifactsLocation}/DSC/SQLACCOUNTS.zip?raw=true'
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        NetBiosDomain: NetBiosDomain
        DomainName: DomainName
        BaseDN: BaseDN
        ServiceAccount: ServiceAccount
        InstallAccount: InstallAccount
        AdminCreds: {
          UserName: adminUsername
          Password: 'PrivateSettingsRef:AdminPassword'
        }
      }
    }
    protectedSettings: {
      Items: {
        AdminPassword: adminPassword
      }
    }
  }
}

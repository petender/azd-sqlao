@description('Computer Name')
param computerName string

@description('Install Account that needs SQL Login')
param InstallAccount string

@description('SQL Service Account')
param SvcAccount string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Domain Name')
param DomainName string

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

var ModulesURL = uri(_artifactsLocation, '/DSC/CREATESQLLOGIN.zip${_artifactsLocationSasToken}')
var ConfigurationFunction = 'CREATESQLLOGIN.ps1\\CREATESQLLOGIN'

resource computerName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: '${_artifactsLocation}/DSC/CREATESQLLOGIN.zip?raw=true'
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        computerName: computerName
        InstallAccount: InstallAccount
        SvcAccount: SvcAccount
        NetBiosDomain: NetBiosDomain
        DomainName: DomainName
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

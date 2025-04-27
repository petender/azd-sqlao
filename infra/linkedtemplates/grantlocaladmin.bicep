@description('Computer Name')
param computerName string

@description('Account that needs Local Admin Rights')
param Account string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('Region of Resources')
param location string

param TimeZone string

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param _artifactsLocation string 
@description('Auto-generated token to access _artifactsLocation')
@secure()
param _artifactsLocationSasToken string

var ModulesURL = uri(_artifactsLocation, '/DSC/GRANTLOCALADMIN.zip${_artifactsLocationSasToken}')
var ConfigurationFunction = 'GRANTLOCALADMIN.ps1\\GRANTLOCALADMIN'

resource computerName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: '${_artifactsLocation}/DSC/GRANTLOCALADMIN.zip?raw=true'
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        Account: Account
        NetBiosDomain: NetBiosDomain
        TimeZone: TimeZone
      }
    }
    protectedSettings: {}
  }
}

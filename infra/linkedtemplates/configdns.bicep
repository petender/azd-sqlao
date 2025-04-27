@description('Computer Name')
param computerName string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('The FQDN of the AD Domain created ')
param InternaldomainName string

@description('The name of Reverse Lookup Zone 1 Network ID')
param ReverseLookup1 string

@description('DC! Last IP Octet')
param dc1lastoctet string

@description('Region of Resources')
param location string

@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param _artifactsLocation string 
@description('Auto-generated token to access _artifactsLocation')
@secure()
param _artifactsLocationSasToken string

var ModulesURL = uri(_artifactsLocation, '/DSC/CONFIGDNS.zip${_artifactsLocationSasToken}')
var ConfigurationFunction = 'CONFIGDNS.ps1\\CONFIGDNS'

resource computerName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: '${_artifactsLocation}/DSC/CONFIGDNS.zip?raw=true'
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        computerName: computerName
        NetBiosDomain: NetBiosDomain
        InternaldomainName: InternaldomainName
        ReverseLookup1: ReverseLookup1
        dc1lastoctet: dc1lastoctet
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

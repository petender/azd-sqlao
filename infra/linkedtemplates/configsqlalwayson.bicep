@description('Computer Name')
param computerName string

@description('SQL Availability Group Name')
param SQLAGName string

@description('SQL Client Access Point Name')
param SQLAPName string

@description('SQL Client Access Point IP')
param SQLAPIP string

@description('SQL Node1')
param SQLNode1 string

@description('SQL Node2')
param SQLNode2 string

@description('SQL Datbase Name')
param SQLDBName string

@description('SQL DB Owner Name')
param SQLDBOwner string

@description('SQL Service Account')
param SQLServiceAccount string

@description('NetBios Domain Name')
param NetBiosDomain string

@description('The FQDN of the AD Domain created ')
param domainName string

@description('Storage Account Name')
param StorageAccountName string

@description('Storage Account Key')
param StorageAccountKey string

@description('Storage Endpoint')
param StorageEndpoint string

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

var ModulesURL = uri(_artifactsLocation, '/DSC/CONFIGSQLALWAYSON.zip${_artifactsLocationSasToken}')
var ConfigurationFunction = 'CONFIGSQLALWAYSON.ps1\\CONFIGSQLALWAYSON'

resource computerName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: '${_artifactsLocation}/DSC/CONFIGSQLALWAYSON.zip?raw=true'
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        SQLAGName: SQLAGName
        SQLAPName: SQLAPName
        SQLAPIP: SQLAPIP
        SQLNode1: SQLNode1
        SQLNode2: SQLNode2
        SQLDBName: SQLDBName
        SQLServiceAccount: SQLServiceAccount
        NetBiosDomain: NetBiosDomain
        DomainName: domainName
        StorageAccountName: StorageAccountName
        StorageAccountKey: StorageAccountKey
        StorageEndpoint: StorageEndpoint
        AdminCreds: {
          UserName: adminUsername
          Password: 'PrivateSettingsRef:AdminPassword'
        }
        SQLDBOwnerCreds: {
          UserName: SQLDBOwner
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

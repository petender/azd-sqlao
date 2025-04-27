@description('Computer Name')
param computerName string

@description('Default Gateway for 2nd Nic')
param NextHop string

@description('Subnet for 1st Nic')
param PrivateSubnet string

@description('Subnet for 2nd Nic')
param PublicSubnet string

@description('Region of Resources')
param location string

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param _artifactsLocation string 
@description('Auto-generated token to access _artifactsLocation')
@secure()
param _artifactsLocationSasToken string

var ModulesURL = uri(_artifactsLocation, '/DSC/ROUTING.zip${_artifactsLocationSasToken}')
var ConfigurationFunction = 'ROUTING.ps1\\ROUTING'

resource computerName_Microsoft_Powershell_DSC 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${computerName}/Microsoft.Powershell.DSC'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    settings: {
      ModulesUrl: '${_artifactsLocation}/DSC/ROUTING.zip?raw=true'
      ConfigurationFunction: ConfigurationFunction
      Properties: {
        NextHop: NextHop
        PrivateSubnet: PrivateSubnet
        PublicSubnet: PublicSubnet
      }
    }
    protectedSettings: {}
  }
}

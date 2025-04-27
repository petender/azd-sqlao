targetScope = 'resourceGroup'


@description('The name of the Administrator of the new VM and Domain')
param adminUsername string

@description('The password for the Administrator account of the new VM and Domain')
@secure()
param adminPassword string

@description('Windows OS License Type')
@allowed([
  'None'
  'Windows_Server'
])
param WindowsLicenseType string = 'None'

@description('SQL License Type')
@allowed([
  'AHUB'
  'DR'
  'PAYG'
])
param SQLLicenseType string = 'AHUB'

@description('Availability Set Name')
param AvailabilitySetName string

@description('Load Balancer Name')
param LoadBalancerName string

@description('SQL Service Account Name')
param ServiceAccount string

@description('SQL Install Account Name')
param InstallAccount string

@description('SQL Node1 Number')
param OSDiskType string

@description('Windows Failover Cluster Name')
param SqlClusterName string

@description('SQL Availability Group Name')
param SQLAGName string

@description('SQL Access Point Name')
param SQLAPName string

@description('SQL Node1 Number (Example:  01)')
param SQLNode1 string

@description('SQL Node2 Number (Example:  02)')
param SQLNode2 string

@description('SQL Access Point Last Octet (Example:  10)')
param SQLLastAPOctet string

@description('SQL Node1 Last Private Octet (Example:  11)')
param SQL1LastPrivOctet string

@description('SQL Node2 Last Private Octet (Example:  12)')
param SQL2LastPrivOctet string

@description('SQL Node1 Last Public Octet (Example:  11)')
param SQL1LastPubOctet string

@description('SQL Node2 Last Public Octet (Example:  12)')
param SQL2LastPubOctet string

@description('SQL Node1 Default Gateway Last Data Octet (Example:  1)')
param SQL1DGLastPubOctet string

@description('SQL Node2 Default Gateway Last Data Octet (Example:  1)')
param SQL2DGLastPubOctet string

@description('Environment Naming Convention')
@minLength(1)
@maxLength(40)
param NamingConvention string 

@description('Environment Naming Convention')
@minLength(3)
@maxLength(24)
param StorageAccountPrefix string 

@description('Sub DNS Domain Name Example:  sub1. must include a DOT AT END')
param SubDNSDomain string 

@description('Sub DNS Domain Name Example:  DC=sub2,DC=sub1, must include COMMA AT END')
param SubDNSBaseDN string 

@description('NetBios Parent Domain Name')
@maxLength(15)
param NetBiosDomain string 

@description('NetBios Domain Name')
param InternalDomain string 

@description('Internal Top-Level Domain Name')
@allowed([
  'com'
  'net'
  'org'
  'edu'
  'gov'
  'mil'
  'us'
  'tk'
  'ml'
  'local'
])
param InternalTLD string 

@description('VNet1 Prefix')
param VNet1ID string 

@description('DNS Reverse Lookup Zone1 Prefix')
param ReverseLookup1param string 

@description('Domain Controller1 OS Version')
@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
  '2012-R2-Datacenter'
])
param DC1OSVersion string 

@description('Tools Machine OS Version')
@allowed([
  '2019-Datacenter'
  '2016-Datacenter'
  '2012-R2-Datacenter'
])
param ToolOSVersion string 

@description('Domain Controller1 VMSize')
param DC1VMSize string 

@description('Tools Machine VMSize')
param ToolVMSize string 

@description('SQL VMSize')
param SQLVMSize string 

@description('The location of resources, such as templates and DSC modules, that the template depends on')
param _artifactsLocation string 
@description('Auto-generated token to access _artifactsLocation. Leave it blank unless you need to provide your own value.')
@secure()
param _artifactsLocationSasToken string 

var vnet1Name = '${NamingConvention}-VNet1'
var vnet1Prefix = '${VNet1ID}.0.0/16'
var vnet1subnet1Name = '${NamingConvention}-VNet1-Subnet1'
var vnet1subnet1Prefix = '${VNet1ID}.1.0/24'
var vnet1subnet2Name = '${NamingConvention}-VNet1-Subnet2'
var vnet1subnet2Prefix = '${VNet1ID}.2.0/24'
var vnet1BastionsubnetPrefix = '${VNet1ID}.253.0/24'
var StorageAccountName = '${StorageAccountPrefix}${uniqueString(resourceGroup().id)}'
var StorageEndpoint = 'core.windows.net'
var dc1name = '${NamingConvention}-dc-01'
var dc1IP = '${VNet1ID}.1.${dc1lastoctet}'
var ReverseLookup1 = '1.${ReverseLookup1param}'
var dc1lastoctet = '101'
var toollastoctet = '201'
var toolname = 'toolVM-01'
var toolIP = '${VNet1ID}.2.${toollastoctet}'
var DCDataDisk1Name = 'NTDS'
var InternaldomainName = '${SubDNSDomain}${InternalDomain}.${InternalTLD}'
var BaseDN = '${SubDNSBaseDN}DC=${InternalDomain},DC=${InternalTLD}'
var sqldbname = '${NamingConvention}-db01'
var sqlname1 = '${NamingConvention}-sql-${SQLNode1}'
var sqlname2 = '${NamingConvention}-sql-${SQLNode2}'
var sqlapIP = '${VNet1ID}.2.${SQLLastAPOctet}'
var sql1privIP = '${VNet1ID}.1.${SQL1LastPrivOctet}'
var sql2privIP = '${VNet1ID}.1.${SQL2LastPrivOctet}'
var sql1pubIP = '${VNet1ID}.2.${SQL1LastPubOctet}'
var sql2pubIP = '${VNet1ID}.2.${SQL2LastPubOctet}'
var sql1DGpubIP = '${VNet1ID}.2.${SQL1DGLastPubOctet}'
var sql2DGpubIP = '${VNet1ID}.2.${SQL2DGLastPubOctet}'
var Subnet1ID = '${VNet1ID}.1'
var Subnet2ID = '${VNet1ID}.2'
var SRVOUPath = 'OU=Servers,${BaseDN}'
var LoadBalancerSku = 'Standard'

module VNet1 'linkedtemplates/vnet.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/vnet.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'VNet1'
  params: {
    vnetName: vnet1Name
    vnetprefix: vnet1Prefix
    subnet1Name: vnet1subnet1Name
    subnet1Prefix: vnet1subnet1Prefix
    subnet2Name: vnet1subnet2Name
    subnet2Prefix: vnet1subnet2Prefix
    BastionsubnetPrefix: vnet1BastionsubnetPrefix
    location: resourceGroup().location
  }
}

module BastionHost1 'linkedtemplates/bastionhost.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/bastionhost.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'BastionHost1'
  params: {
    publicIPAddressName: '${vnet1Name}-Bastion-pip'
    AllocationMethod: 'Static'
    vnetName: vnet1Name
    subnetName: 'AzureBastionSubnet'
    location: resourceGroup().location
  }
  dependsOn: [
    VNet1
  ]
}

module deployDC1VM 'linkedtemplates/1nic-2disk-vm.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/1nic-2disk-vm.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'deployDC1VM'
  params: {
    computerName: dc1name
    computerIP: dc1IP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: DC1OSVersion
    LicenseType: WindowsLicenseType
    DataDisk1Name: DCDataDisk1Name
    VMSize: DC1VMSize
    vnetName: vnet1Name
    subnetName: vnet1subnet1Name
    vnetprefix: vnet1Prefix
    subnetprefix: vnet1subnet1Prefix
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    VNet1
  ]
}

module promotedc1 'linkedtemplates/firstdc.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/firstdc.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'promotedc1'
  params: {
    computerName: dc1name
    NetBiosDomain: NetBiosDomain
    domainName: InternaldomainName
    adminUsername: adminUsername
    adminPassword: adminPassword
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    deployDC1VM
  ]
}

module updatevnet1dns 'linkedtemplates/updatevnetdns.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/updatevnetdns.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'updatevnet1dns'
  params: {
    vnetName: vnet1Name
    vnetprefix: vnet1Prefix
    subnet1Name: vnet1subnet1Name
    subnet1Prefix: vnet1subnet1Prefix
    subnet2Name: vnet1subnet2Name
    subnet2Prefix: vnet1subnet2Prefix
    BastionsubnetPrefix: vnet1BastionsubnetPrefix
    DNSServerIP: [
      dc1IP
    ]
    location: resourceGroup().location
  }
  dependsOn: [
    promotedc1
  ]
}

module restartdc1 'linkedtemplates/restartvm.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/restartvm.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'restartdc1'
  params: {
    computerName: dc1name
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    updatevnet1dns
  ]
}

module configdns 'linkedtemplates/configdns.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/configdns.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'configdns'
  params: {
    computerName: dc1name
    NetBiosDomain: NetBiosDomain
    InternaldomainName: InternaldomainName
    ReverseLookup1: ReverseLookup1
    dc1lastoctet: dc1lastoctet
    adminUsername: adminUsername
    adminPassword: adminPassword
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    restartdc1
  ]
}

module createous 'linkedtemplates/createous.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/createous.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'createous'
  params: {
    computerName: dc1name
    BaseDN: BaseDN
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    configdns
  ]
}

module deployToolVM 'linkedtemplates/1nic-1disk-vm.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/1nic-1disk-vm.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'deployToolVM'
  params: {
    computerName: toolname
    computerIP: toolIP
    Publisher: 'MicrosoftWindowsServer'
    Offer: 'WindowsServer'
    OSVersion: ToolOSVersion
    LicenseType: WindowsLicenseType
    VMSize: ToolVMSize
    vnetName: vnet1Name
    subnetName: vnet1subnet2Name
    vnetPrefix: vnet1Prefix
    subnetPrefix: vnet1subnet2Prefix
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
  ]
}

module DomainJoinToolVM 'linkedtemplates/domainjoin.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/domainjoin.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DomainJoinToolVM'
  params: {
    computerName: toolname
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    deployToolVM
  ]
}

module InstallSQLManagementStudio 'linkedtemplates/ssms.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/ssms.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'InstallSQLManagementStudio'
  params: {
    computerName: toolname
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    DomainJoinToolVM
  ]
}

module CreateSQLAccounts 'linkedtemplates/sqlaccounts.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/sqlaccounts.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'CreateSQLAccounts'
  params: {
    computerName: dc1name
    BaseDN: BaseDN
    DomainName: InternaldomainName
    NetBiosDomain: NetBiosDomain
    ServiceAccount: ServiceAccount
    InstallAccount: InstallAccount
    adminUsername: adminUsername
    adminPassword: adminPassword
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    createous
  ]
}

module DeploySQLAvailabilitySet 'linkedtemplates/availabilityset.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/AvailabilitySet.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DeploySQLAvailabilitySet'
  params: {
    AvailabilitySetName: AvailabilitySetName
    UpdateDomainCount: '5'
    FaultDomainCount: '2'
    Sku: 'Aligned'
    location: resourceGroup().location
  }
}

module DeploySQL2019AzureVM1 'linkedtemplates/sql-servervm-multi-nic.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/sql-servervm-multi-nic.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DeploySQL2019AzureVM1'
  params: {
    computerName: sqlname1
    LicenseType: WindowsLicenseType
    SQLLicenseType: SQLLicenseType
    AvailabilitySetName: AvailabilitySetName
    PrivateIP: sql1privIP
    PublicIP: sql1pubIP
    subnet1Name: vnet1subnet1Name
    subnet2Name: vnet1subnet2Name
    vnetName: vnet1Name
    osDiskType: OSDiskType
    dataDisks: [
      {
        lun: 0
        createOption: 'attach'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        id: null
        name: '${sqlname1}_DataDisk_0'
        storageAccountType: null
        diskSizeGB: null
        diskEncryptionSet: null
      }
      {
        lun: 1
        createOption: 'attach'
        caching: 'None'
        writeAcceleratorEnabled: false
        id: null
        name: '${sqlname1}_DataDisk_1'
        storageAccountType: null
        diskSizeGB: null
        diskEncryptionSet: null
      }
    ]
    dataDiskResources: [
      {
        name: '${sqlname1}_DataDisk_0'
        sku: OSDiskType
        properties: {
          diskSizeGB: 1024
          creationData: {
            createOption: 'empty'
          }
        }
      }
      {
        name: '${sqlname1}_DataDisk_1'
        sku: OSDiskType
        properties: {
          diskSizeGB: 1024
          creationData: {
            createOption: 'empty'
          }
        }
      }
    ]
    VMSize: SQLVMSize
    adminUsername: adminUsername
    adminPassword: adminPassword
    sqlConnectivityType: 'Private'
    sqlPortNumber: 1433
    sqlStorageWorkloadType: 'OLTP'
    sqlStorageDisksConfigurationType: 'NEW'
    sqlAutopatchingDayOfWeek: 'Sunday'
    sqlAutopatchingStartHour: '2'
    sqlAutopatchingWindowDuration: '60'
    dataPath: 'F:\\data'
    dataDisksLUNs: [
      0
    ]
    logPath: 'G:\\log'
    logDisksLUNs: [
      1
    ]
    tempDbPath: 'D:\\tempDb'
    rServicesEnabled: 'false'
    location: resourceGroup().location
  }
  dependsOn: [
    createous
    DeploySQLAvailabilitySet
  ]
}

module DeploySQL2019AzureVM2 'linkedtemplates/sql-servervm-multi-nic.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/sql-servervm-multi-nic.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DeploySQL2019AzureVM2'
  params: {
    computerName: sqlname2
    LicenseType: WindowsLicenseType
    SQLLicenseType: SQLLicenseType
    AvailabilitySetName: AvailabilitySetName
    PrivateIP: sql2privIP
    PublicIP: sql2pubIP
    subnet1Name: vnet1subnet1Name
    subnet2Name: vnet1subnet2Name
    vnetName: vnet1Name
    osDiskType: OSDiskType
    dataDisks: [
      {
        lun: 0
        createOption: 'attach'
        caching: 'ReadOnly'
        writeAcceleratorEnabled: false
        id: null
        name: '${sqlname2}_DataDisk_0'
        storageAccountType: null
        diskSizeGB: null
        diskEncryptionSet: null
      }
      {
        lun: 1
        createOption: 'attach'
        caching: 'None'
        writeAcceleratorEnabled: false
        id: null
        name: '${sqlname2}_DataDisk_1'
        storageAccountType: null
        diskSizeGB: null
        diskEncryptionSet: null
      }
    ]
    dataDiskResources: [
      {
        name: '${sqlname2}_DataDisk_0'
        sku: OSDiskType
        properties: {
          diskSizeGB: 1024
          creationData: {
            createOption: 'empty'
          }
        }
      }
      {
        name: '${sqlname2}_DataDisk_1'
        sku: OSDiskType
        properties: {
          diskSizeGB: 1024
          creationData: {
            createOption: 'empty'
          }
        }
      }
    ]
    VMSize: SQLVMSize
    adminUsername: adminUsername
    adminPassword: adminPassword
    sqlConnectivityType: 'Private'
    sqlPortNumber: 1433
    sqlStorageWorkloadType: 'OLTP'
    sqlStorageDisksConfigurationType: 'NEW'
    sqlAutopatchingDayOfWeek: 'Sunday'
    sqlAutopatchingStartHour: '2'
    sqlAutopatchingWindowDuration: '60'
    dataPath: 'F:\\data'
    dataDisksLUNs: [
      0
    ]
    logPath: 'G:\\log'
    logDisksLUNs: [
      1
    ]
    tempDbPath: 'D:\\tempDb'
    rServicesEnabled: 'false'
    location: resourceGroup().location
  }
  dependsOn: [
    createous
    DeploySQLAvailabilitySet
  ]
}

module DomainJoinSQL1VM 'linkedtemplates/domainjoin.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/domainjoin.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DomainJoinSQL1VM'
  params: {
    computerName: sqlname1
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
    DeploySQL2019AzureVM1
  ]
}

module DomainJoinSQL2VM 'linkedtemplates/domainjoin.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/domainjoin.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DomainJoinSQL2VM'
  params: {
    computerName: sqlname2
    domainName: InternaldomainName
    OUPath: SRVOUPath
    domainJoinOptions: 3
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
  }
  dependsOn: [
    createous
    DeploySQL2019AzureVM2
  ]
}

module GrantInstallLocalAdminSQLVM1 'linkedtemplates/grantlocaladmin.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/grantlocaladmin.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'GrantInstallLocalAdminSQLVM1'
  params: {
    computerName: sqlname1
    Account: InstallAccount
    NetBiosDomain: NetBiosDomain
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinSQL1VM
  ]
}

module GrantInstallLocalAdminSQLVM2 'linkedtemplates/grantlocaladmin.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/grantlocaladmin.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'GrantInstallLocalAdminSQLVM2'
  params: {
    computerName: sqlname2
    Account: InstallAccount
    NetBiosDomain: NetBiosDomain
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    DomainJoinSQL2VM
  ]
}

module CreateSQLLoginforInstallSQLVM1 'linkedtemplates/createsqllogin.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/createsqllogin.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'CreateSQLLoginforInstallSQLVM1'
  params: {
    computerName: sqlname1
    InstallAccount: InstallAccount
    SvcAccount: ServiceAccount
    NetBiosDomain: NetBiosDomain
    DomainName: InternaldomainName
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    GrantInstallLocalAdminSQLVM1
  ]
}

module CreateSQLLoginforInstallSQLVM2 'linkedtemplates/createsqllogin.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/createsqllogin.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'CreateSQLLoginforInstallSQLVM2'
  params: {
    computerName: sqlname2
    InstallAccount: InstallAccount
    SvcAccount: ServiceAccount
    NetBiosDomain: NetBiosDomain
    DomainName: InternaldomainName
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    GrantInstallLocalAdminSQLVM2
  ]
}

module InstallWFCSQLVM1 'linkedtemplates/installwfc.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/installwfc.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'InstallWFCSQLVM1'
  params: {
    computerName: sqlname1
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    CreateSQLLoginforInstallSQLVM1
  ]
}

module InstallWFCSQLVM2 'linkedtemplates/installwfc.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/installwfc.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'InstallWFCSQLVM2'
  params: {
    computerName: sqlname2
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    CreateSQLLoginforInstallSQLVM2
  ]
}

module RoutingSQLVM1 'linkedtemplates/routing.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/routing.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'RoutingSQLVM1'
  params: {
    computerName: sqlname1
    NextHop: sql1DGpubIP
    PrivateSubnet: Subnet1ID
    PublicSubnet: Subnet2ID
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    InstallWFCSQLVM1
  ]
}

module RoutingSQLVM2 'linkedtemplates/routing.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/routing.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'RoutingSQLVM2'
  params: {
    computerName: sqlname2
    NextHop: sql2DGpubIP
    PrivateSubnet: Subnet1ID
    PublicSubnet: Subnet2ID
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    InstallWFCSQLVM2
  ]
}

module RestartSQLVM1 'linkedtemplates/restartvm.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/restartvm.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'RestartSQLVM1'
  params: {
    computerName: sqlname1
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    RoutingSQLVM1
  ]
}

module RestartSQLVM2 'linkedtemplates/restartvm.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/restartvm.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'RestartSQLVM2'
  params: {
    computerName: sqlname2
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
    location: resourceGroup().location
  }
  dependsOn: [
    RoutingSQLVM2
  ]
}

module CreateStorage 'linkedtemplates/storage.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/storage.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'CreateStorage'
  params: {
    StorageAccountName: StorageAccountName
    location: resourceGroup().location
  }
  dependsOn: [
    RestartSQLVM1
    RestartSQLVM2
  ]
}

module CreateWFCSQLVM1 'linkedtemplates/createwfc.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/createwfc.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'CreateWFCSQLVM1'
  params: {
    computerName: sqlname1
    SQLClusterName: SqlClusterName
    PrivateSubnet: Subnet1ID
    NetBiosDomain: NetBiosDomain
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    CreateStorage
  ]
}

module CreateWFCSQLVM2 'linkedtemplates/createwfc.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/createwfc.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'CreateWFCSQLVM2'
  params: {
    computerName: sqlname2
    SQLClusterName: SqlClusterName
    PrivateSubnet: Subnet1ID
    NetBiosDomain: NetBiosDomain
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    CreateWFCSQLVM1
  ]
}

module GrantClusterCNO 'linkedtemplates/grantcluster.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/grantcluster.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'GrantClusterCNO'
  params: {
    computerName: dc1name
    SQLClusterName: SqlClusterName
    NetBiosDomain: NetBiosDomain
    BaseDN: BaseDN
    location: resourceGroup().location
    adminUsername: adminUsername
    adminPassword: adminPassword
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    CreateWFCSQLVM2
  ]
}

module EnableSQLAlwaysOnSQLVM1 'linkedtemplates/enablesqlalwayson.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/enablesqlalwayson.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'EnableSQLAlwaysOnSQLVM1'
  params: {
    computerName: sqlname1
    NetBiosDomain: NetBiosDomain
    adminUsername: InstallAccount
    adminPassword: adminPassword
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    CreateWFCSQLVM1
    CreateWFCSQLVM2
    GrantClusterCNO
  ]
}

module EnableSQLAlwaysOnSQLVM2 'linkedtemplates/enablesqlalwayson.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/enablesqlalwayson.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'EnableSQLAlwaysOnSQLVM2'
  params: {
    computerName: sqlname2
    NetBiosDomain: NetBiosDomain
    adminUsername: InstallAccount
    adminPassword: adminPassword
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    EnableSQLAlwaysOnSQLVM1
  ]
}

module ConfigureWFCSQL 'linkedtemplates/configsqlalwayson.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/configsqlalwayson.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'ConfigureWFCSQL'
  params: {
    computerName: sqlname1
    SQLAGName: SQLAGName
    SQLAPName: SQLAPName
    SQLAPIP: sqlapIP
    SQLNode1: sqlname1
    SQLNode2: sqlname2
    SQLDBName: sqldbname
    SQLDBOwner: InstallAccount
    SQLServiceAccount: ServiceAccount
    NetBiosDomain: NetBiosDomain
    domainName: InternaldomainName
    StorageAccountName: StorageAccountName
    StorageEndpoint: StorageEndpoint
    StorageAccountKey: CreateStorage.outputs.Key
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: resourceGroup().location
    _artifactsLocation: _artifactsLocation
    _artifactsLocationSasToken: _artifactsLocationSasToken
  }
  dependsOn: [
    EnableSQLAlwaysOnSQLVM1
    EnableSQLAlwaysOnSQLVM2
  ]
}

module DeploySQLLoadBalancer 'linkedtemplates/loadbalancer.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/LoadBalancer.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DeploySQLLoadBalancer'
  params: {
    LoadBalancerName: LoadBalancerName
    SQLAPName: SQLAPName
    SQLAPIP: sqlapIP
    vnetName: vnet1Name
    subnetName: vnet1subnet2Name
    Sku: LoadBalancerSku
    location: resourceGroup().location
  }
  dependsOn: [
    ConfigureWFCSQL
  ]
}

module DeploySQL2019AzureVM1_LB 'linkedtemplates/sql-servervm-multi-nic-lb.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/sql-servervm-multi-nic-lb.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DeploySQL2019AzureVM1-LB'
  params: {
    computerName: sqlname1
    LoadBalancerName: LoadBalancerName
    PublicIP: sql1pubIP
    subnetName: vnet1subnet2Name
    vnetName: vnet1Name
    location: resourceGroup().location
  }
  dependsOn: [
    DeploySQLLoadBalancer
  ]
}

module DeploySQL2019AzureVM2_LB 'linkedtemplates/sql-servervm-multi-nic-lb.bicep' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('SQLAO/.azure/linkedtemplates/sql-servervm-multi-nic-lb.json', parameters('_artifactsLocationSasToken')))]*/ = {
  name: 'DeploySQL2019AzureVM2-LB'
  params: {
    computerName: sqlname2
    LoadBalancerName: LoadBalancerName
    PublicIP: sql2pubIP
    subnetName: vnet1subnet2Name
    vnetName: vnet1Name
    location: resourceGroup().location
  }
  dependsOn: [
    DeploySQLLoadBalancer
  ]
}


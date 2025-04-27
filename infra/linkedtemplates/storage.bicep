@description('Name of Storage Account')
param StorageAccountName string

@description('Region of Resources')
param location string

var storageAccountId = storageAccount.id

resource storageAccount 'Microsoft.Storage/storageAccounts@2018-02-01' = {
  name: StorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

output Key string = listKeys(storageAccountId, '2019-04-01').keys[0].value

@description('Deployment location')
param location string = resourceGroup().location

@description('Name prefix; final name will be made unique')
param namePrefix string = 'biceplab'

@description('Allow public blob access? (disabled by default)')
param allowBlobPublicAccess bool = false

// Create a globally-unique, lowercase storage account name based on the RG id
var uniqueSuffix = toLower(uniqueString(resourceGroup().id))
var saName = toLower('${namePrefix}${uniqueSuffix}')

resource sa 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: saName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  }
}

output storageAccountName string = sa.name

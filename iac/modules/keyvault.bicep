param location string
param prefix string

var uniqueStr = uniqueString(subscription().subscriptionId, resourceGroup().id)
var kvName = '${prefix}-${uniqueStr}-kv'

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: kvName  
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: false
    enableRbacAuthorization: true
    softDeleteRetentionInDays: 7
    tenantId: subscription().tenantId
  }
}

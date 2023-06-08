param location string
param prefix string
param signedInUserId string 

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

// Key Vault Administrator https://www.azadvertizer.net/azrolesadvertizer/00482a5a-887f-4fb3-b363-3b7fe8e74483.html
var keyVaultAdministratorRoleId = '00482a5a-887f-4fb3-b363-3b7fe8e74483'

resource readersRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: kv
  name: guid(kv.id, signedInUserId, keyVaultAdministratorRoleId)  
  properties: {
    principalId: signedInUserId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultAdministratorRoleId)
  }  
}

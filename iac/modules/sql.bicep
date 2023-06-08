param location string
param prefix string
param sqlAdminsGroupObjectId string
param sqlAdminsGroupName string
param tenantId string = tenant().tenantId

var sqlServerName = '${prefix}-sql'

resource sqlServer 'Microsoft.Sql/servers@2022-08-01-preview' = {
  name: sqlServerName
  location: location 
  properties: {    
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      sid: sqlAdminsGroupObjectId
      login: sqlAdminsGroupName
      principalType: 'Group'
      tenantId: tenantId
    }
  }
}

var databaseName = '${prefix}-sqldb' 
resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  name: databaseName
  parent: sqlServer 
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
    zoneRedundant: false
    readScale: 'Disabled'
    highAvailabilityReplicaCount: 0
    autoPauseDelay: 0
    requestedBackupStorageRedundancy: 'Local'
    isLedgerOn: false
  }
}

output name string = sqlServerName

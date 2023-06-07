targetScope = 'subscription'

@description('Resources location')
param location string = 'westeurope'

@description('Two first segments of Virtual Network address prefix. For example, if the address prefix is 10.10.0.0/22, then the value of this parameter should be 10.10')
param vnetAddressPrefix string = '10.10'

@description('Lab resources prefix.')
param prefix string = 'iac-ws5'

param administratorUserObjectId string = 'd10ec8a4-91c4-43e4-b26c-565b8c798b2c'

var resourceGroupName = '${prefix}-rg'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module vnet 'modules/vnet.bicep' = {
  name: 'Deploy-VirtualNetwork'
  scope: rg
  params: {
    location: location
    prefix: prefix
    vnetAddressPrefix: vnetAddressPrefix
  }
}

module vpnGateway 'modules/vpnGateway.bicep' = {
  scope: rg
  name: 'Deploy-VPN-Gateway'
  params: {
    gatewaySubnetId: '${vnet.outputs.id}/subnets/GatewaySubnet'
    location: location
    prefix: prefix
  }
}

module dnsResolver 'modules/dnsResolver.bicep' = {
  scope: rg
  name: 'Deploy-Private-DNS-Resolver'
  params: {
    location: location
    prefix: prefix
    subnetId: '${vnet.outputs.id}/subnets/dnsresolver-inbound-snet'
    vnetId: vnet.outputs.id
  }
}

module keyvault 'modules/keyvault.bicep' = {
  scope: rg
  name: 'Deploy-KeyVault'
  params: {
    location: location
    prefix: prefix
  }
}


module sql 'modules/sql.bicep' = {
  scope: rg
  name: 'Deploy-SQL'
  params: {
    location: location
    prefix: prefix
    administratorUserObjectId: administratorUserObjectId
  }
} 

module sqlPrivateEndpoint 'modules/sqlPrivateEndpoint.bicep' = {
  scope: rg
  name: 'Deploy-SQLServer-PrivateEndpoint'
  params: {
    linkedVNetId: vnet.outputs.id
    privateLinkSubnetId: '${vnet.outputs.id}/subnets/plinks-snet'
    location: location
    sqlServerName: sql.outputs.name
  }
}

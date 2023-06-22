param location string = resourceGroup().location
param prefix string = 'iac-ws5'

var virtualNetworkName = '${prefix}-vnet'

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkName
}

var dnsResolverName = '${prefix}-dnsresolver'

resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: dnsResolverName
  location: location
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource inboundEndpoint 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  name: 'inbound'
  parent: dnsResolver
  location: location
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: '${vnet.id}/subnets/dnsresolver-inbound-snet'
        }
        privateIpAllocationMethod: 'Dynamic'
      }
    ]
  }
}

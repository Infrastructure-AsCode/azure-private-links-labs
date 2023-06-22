@description('VPN Gateway Location')
param location string
@description('Resources Prefix based on Naming Convention')
param prefix string
@description('Gateway Subnet ID')
param gatewaySubnetId string
@description('Tenant ID')
param tenantId string = tenant().tenantId
@description('List of VPN Client Address Prefixes')
param vpnClientSddressPrefixes array = [
  '172.0.0.0/16'
]

var vpnGatewayName = '${prefix}-vgw'

var vpnGatewayPublicIPName = '${vpnGatewayName}-pip'

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: vpnGatewayPublicIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource virtualNetworkGateways 'Microsoft.Network/virtualNetworkGateways@2022-09-01' = {
  name: vpnGatewayName
  location: location
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: gatewaySubnetId
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    vpnClientConfiguration: {      
      vpnClientAddressPool: {
        addressPrefixes: vpnClientSddressPrefixes
      }
      vpnClientProtocols: [
        'OpenVPN'
      ]
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientRootCertificates: []
      vpnClientRevokedCertificates: []
      vngClientConnectionConfigurations: []
      radiusServers: []
      vpnClientIpsecPolicies: []
      aadTenant: '${environment().authentication.loginEndpoint}${tenantId}/'
      aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
      aadIssuer: 'https://sts.windows.net/${tenantId}/'
    }
    customRoutes: {
      addressPrefixes: []
    }
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }  
}


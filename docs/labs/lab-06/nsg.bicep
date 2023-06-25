param location string = resourceGroup().location
param prefix string = 'iac-ws5'

var nsgName = '${prefix}-ple-nsg'
var vpnClientAddressPrefix = '172.0.0.0/16'
var privateLinkAddressPrefix = '10.10.1.0/24'
var testVMSubnetAddressPrefix = '10.10.0.64/26'

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowHTTPSAccessFromVPN'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: vpnClientAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSQLAccessFromVPN'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '1443'
          sourceAddressPrefix: vpnClientAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }      
      {
        name: 'DenyHTTPSAccessFromTestVM'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: testVMSubnetAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          access: 'Deny'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'DenySQLAccessFromTestVM'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '1443'
          sourceAddressPrefix: testVMSubnetAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          access: 'Deny'
          priority: 130
          direction: 'Inbound'
        }
      }      
    ]
  }
}

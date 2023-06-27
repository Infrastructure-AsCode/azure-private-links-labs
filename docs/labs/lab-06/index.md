# lab-06 - Network Security Groups support for Private Endpoints

If you want to control traffic to and from a private endpoint, you must configure the Network Security Group (NSG) to allow or deny traffic to and from the private endpoint. You can do this by adding the private endpoint's IP address to the NSG's inbound and outbound security rules. 
For each rule, you can specify source and destination, port, and protocol. Security rules are evaluated and applied based on the five-tuple (source, source port, destination, destination port, and protocol) information. 

In this lab we will implement the following requirements:

- allow access to SQL server and Azure KeyVault from IP range configured for Point-To-Site VPN
- deny access to SQL server and Azure KeyVault from testVM

## Task #1 - test connectivity to SQL server and Azure KeyVault

First check that you can connect to SQL server and Azure KeyVault both from your PC and from testVM. Make sure that you are connected to VPN.

```powershell
$keyvaultName = (az keyvault list -g iac-ws5-rg --query '[].name' -o tsv)
az keyvault secret list --vault-name $keyvaultName
```

From the Azure Data Studio, try to connect to your SQL Server.

## Task #2 - implement and deploy Network Security Group using Bicep

Get private endpoints (`plinks-snet`) and  address prefix: 

```powershell
az network vnet subnet show -n plinks-snet -g iac-ws5-rg --vnet-name iac-ws5-vnet --query addressPrefix -o tsv
az network vnet subnet show -n testvm-snet -g iac-ws5-rg --vnet-name iac-ws5-vnet --query addressPrefix -o tsv
```

Create new `nsg.bicep` file with following content. Use address prefix for `privateLinkAddressPrefix` and `testVMSubnetAddressPrefix` variables from the previous step (if you haven't change the default values, then these values are the same as in the example below)

```bicep
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
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: vpnClientAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          priority: 100
        }
      }
      {
        name: 'AllowSQLAccessFromVPN'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '1443'
          sourceAddressPrefix: vpnClientAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          priority: 110
        }
      }      
      {
        name: 'DenyHTTPSAccessFromTestVM'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          direction: 'Inbound'
          access: 'Deny'
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: testVMSubnetAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          priority: 120
        }
      }
      {
        name: 'DenySQLAccessFromTestVM'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          direction: 'Inbound'
          access: 'Deny'
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '1443'
          sourceAddressPrefix: testVMSubnetAddressPrefix
          destinationAddressPrefix: privateLinkAddressPrefix
          priority: 130
        }
      }      
    ]
  }
}
```

Deploy NSG

```powershell	
az deployment group create -g iac-ws5-rg --template-file .\nsg.bicep -n 'Deploy-NSG'
```

It will deploy new NSG called `iac-ws5-ple-nsg` with four rules.

!!! info "Network security groups support for private endpoints"
     In order to enable NSG for private endpoint, you will need to set subnet's `PrivateEndpointNetworkPolicies` property to `Enabled` on the subnet containing private endpoint resources.

Assign NSG to the subnet and enable `PrivateEndpointNetworkPolicies` property

```powershell
az network vnet subnet update -g iac-ws5-rg --vnet-name iac-ws5-vnet -n plinks-snet --network-security-group iac-ws5-ple-nsg --disable-private-endpoint-network-policies false
```

## Task #3 - test connectivity to SQL server and Azure KeyVault

Now, test connectivity to SQL server and Azure KeyVault both from your PC. You should be able to connect to SQL server and Azure KeyVault. 
Next, test connectivity to SQL server and Azure KeyVault from testVM. You should not be able to connect to SQL server and Azure KeyVault.

!!! info "Note"
    It might take some minutes for NSG changes to take effect.


## Links

- [Manage network policies for private endpoints](https://learn.microsoft.com/en-us/azure/private-link/disable-private-endpoint-network-policy?tabs=network-policy-portal)
- [Network security groups](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- [Tutorial: Restrict network access to PaaS resources with virtual network service endpoints using the Azure portal](https://learn.microsoft.com/en-us/azure/virtual-network/tutorial-restrict-network-access-to-resources)
- [Tutorial: Log network traffic to and from a virtual machine using the Azure portal](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-portal)
- [Flow logging for network security groups](https://learn.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
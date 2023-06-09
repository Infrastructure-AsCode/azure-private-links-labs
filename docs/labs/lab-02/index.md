# lab-02 - create a private endpoint for Azure KeyVault using Bicep

There are several ways you can create Azure Private Endpoint. You can use Azure Portal, Azure CLI, Azure PowerShell, ARM templates, or Bicep.
In this lab, we'll use Bicep to create a private endpoint for Azure KeyVault.

## Task #1 - implement Bicep template

Create new file `keyvaultPrivateEndpoint.bicep` with the following content:

```bicep
param location string = resourceGroup().location
param prefix string = 'iac-ws5'

var uniqueStr = uniqueString(subscription().subscriptionId, resourceGroup().id)
var kvName = '${prefix}-${uniqueStr}-kv'

var pleName = '${kvName}-ple'

resource kv 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: kvName
}

var virtualNetworkName = '${prefix}-vnet'
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkName
}

var privateDnsZoneName = 'privatelink.vaultcore.azure.net' 

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: uniqueString(vnet.id)
  parent: privateDnsZone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }  
}

var groupName = 'vault'
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: pleName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: pleName
        properties: {
          groupIds: [
            groupName
          ]
          privateLinkServiceId: kv.id
        }
      }
    ]
    subnet: {
      id: '${vnet.id}/subnets/plinks-snet'
    }
  }
}

resource privateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = {
  name: '${groupName}-PrivateDnsZoneGroup'
  parent: privateEndpoint
  properties:{
    privateDnsZoneConfigs: [
      {
        name: privateDnsZoneName
        properties:{
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
```

Save the file and deploy it using the following command:

```powershell
az deployment group create -g iac-ws5-rg --template-file .\keyvaultPrivateEndpoint.bicep -n 'Deploy-KeyVault-PrivateEndpoint'
```

It will deploy the following Azure resources:

- [Microsoft.Network/privateEndpoints](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/privateendpoints): The private endpoint that you use to access the instance of Azure KeyVault.
- [Microsoft.Network/privateDnsZones](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/privatednszones): The zone that you use to resolve the private endpoint IP address. In our case it's `privatelink.vaultcore.azure.net`
- [Microsoft.Network/privateDnsZones/virtualNetworkLinks](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/privatednszones/virtualnetworklinks): The virtual network link that you use to associate the private DNS zone with a virtual network.
- [Microsoft.Network/privateEndpoints/privateDnsZoneGroups](https://learn.microsoft.com/en-us/azure/templates/microsoft.network/privateendpoints/privateDnsZoneGroups): The zone group that you use to associate the private endpoint with a private DNS zone. In our case it's `vault`

## Task #2 - access the Azure KeyVault privately from the testVM

Connect to your testVM using RDP, open PowerShell console and try to resolve the Azure KeyVault DNS name:

```powershell
Resolve-DnsName -Name 'iac-ws5-<uniqueStr>-kv.vault.azure.net'
```

For my keyvault instance it returns the following result:

```text
Name                             Type     TTL   Section    NameHost
----                             ----     ---   -------    --------
iac-ws5-....-kv.vault.azure.net  CNAME    60    Answer     iac-ws5-....-kv.privatelink.vaultcore.azure.net


Name       : iac-ws5-....-kv.privatelink.vaultcore.azure.net
QueryType  : A
TTL        : 10
Section    : Answer
IP4Address : 10.10.1.4
```


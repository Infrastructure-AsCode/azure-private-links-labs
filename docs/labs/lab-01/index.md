# lab-01 - provisioning of lab resources

As always, we need to provision lab environment before we can start working on the lab tasks. 

Infrastructure for Lab environment is implemented using `Bicep` and code is located under `iac` folder. Most of the resources are implemented as Bicep modules. The master orchestration Bicep file is `infra.bicep`. It orchestrates deployment of the following resources:

- Private Virtual Network
- Azure Cosmos DB
- Azure Storage Account

You can learn implementation details and code structure, but for the efficiency reasons, I pre-built Bicep code into ARM template and made it possible to deploy it right from Azure portal.

## Task #1 - Register required resource providers

Before we deploy lab resources, we need to register required resource providers. This is a one time operation per subscription.

```powershell
az provider register -n Microsoft.Network
az provider register -n Microsoft.OperationalInsights
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Sql
az provider register -n Microsoft.DocumentDB
```

## Task #2 - Authorize the Azure VPN application

1. Sign in to the Azure portal as a user that is assigned the `Global administrator` role.
2. Grant admin consent for your organization. This allows the Azure VPN application to sign in and read user profiles. Copy and paste the URL that pertains to your deployment location in the address bar of your browser:

```txt
https://login.microsoftonline.com/common/oauth2/authorize?client_id=41b23e61-6c1e-4545-b367-cd054e0ed4b4&response_type=code&redirect_uri=https://portal.azure.com&nonce=1234&prompt=admin_consent
```

![01](../../assets/images/lab-01/01.png)

3. Select the account that has the `Global administrator` role if prompted.
4. On the `Permissions requested` page, select `Accept`.

## Task #3 - Deploy lab resources

```powershell
# change directory to iac folder
cd iac

# Deploy Bicep master template
./deploy.ps1
```

!!! info "Estimated deployment time"
    35-40 minutes.

## Task #4 - configure Azure VPN client

First, check that Azure VPN client is installed on your machine. If not, download and install it from [here](https://www.microsoft.com/en-us/p/azure-vpn-client/9np355qt2sqb?activetab=pivot:overviewtab), or use `winget` (only for Windows users):

```powershell
winget install "azure vpn client"
```

Next, download VPN client configuration file from Azure portal. Go to your Virtual network gateway resource `iac-ws5-vgw` and download `VPN client configuration` file.

![download-vpn-config](../../assets/images/lab-01/download-vpn-config.png)


# Prerequisites

## Laptop / PC

You need an laptop. OS installed at this laptop doesn't really matter. The tools we use all work cross platforms. I will be using Windows 11 with PowerShell as my shell.

## Microsoft Teams

Download and install [Microsoft Teams](https://products.office.com/en-US/microsoft-teams/group-chat-software)

## Visual Studio Code

Please [download](https://code.visualstudio.com/download) and install VS Code. It's available for all platforms or install it with `winget` (Windows only)

```powershell
winget install -e --id Microsoft.VisualStudioCode
```

## Bicep plugin

Install Bicep plugin from [marketplace](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) 

## Windows Terminal (if you are using Windows)

Download and install [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab&atc=true) or install it with `winget` (Windows only)

```powershell
winget install -e --id Microsoft.WindowsTerminal
```

## Active Azure account

If you don't have an Azure account, please create one before the workshop.
[Create your Azure free account](https://azure.microsoft.com/en-us/free/?WT.mc_id=AZ-MVP-5003837)

## Install `az cli`

Download and install latest version of `az cli` from [this link](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest&WT.mc_id=AZ-MVP-5003837) or install it with `winget` (Windows only)

```powershell
winget install -e --id Microsoft.AzureCLI
```

If you already have `az cli` installed, make sure that you use the latest version. To make sure, run the following command

```powershell
az upgrade
```

## Test your azure account with `az cli`

Open your terminal (bash, cmd or powershell) and login to your azure account by running this command

```powershell
# Login using your Azure account
az login

# Get a list of available subscriptions
az account list -o table

# Set subscription by subscription id
az account set --subscription  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# Set subscription by name
az account set --subscription subscription_name
```

## Install git

```powershell
# Install git for Mac
brew install git

# Install git with winget
winget install -e --id Git.Git
```

## Install Azure Vpn client

Download and install [Azure VPN Client](https://docs.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant?tabs=azure-ad-md-2-0&WT.mc_id=AZ-MVP-5003837)

or install it with `winget` (Windows only)

```powershell
# Install Azure VPN Client with winget
winget install "azure vpn client"
```

## Install Azure Data Studio

Download and install [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15&WT.mc_id=AZ-MVP-5003837) or install it with `winget` (Windows only).

```powershell
# Install SQL Management Studio with winget
winget install -e --id Microsoft.AzureDataStudio
```

## Install Azure PowerShell module

Make sure that the latest version of Azure PowerShell is installed. See [Install Azure PowerShell module](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell) for detailed information.
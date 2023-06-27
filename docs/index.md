# Working with Azure Private Links

![logo](assets/images/logo.png)

This is level 200 workshop that covers different aspects of working with [Azure Private Links](https://learn.microsoft.com/en-us/azure/private-link/private-link-overview) where you will learn:

- What is Azure Private Link
- What is Azure Private Endpoint
- How Azure Private Link, Azure Private Endpoint, and Azure Private Link service work together to create private connections to Azure resources
- When to use Azure Private Link
- How to configure DNS settings for private endpoints
- How to implement Private Endpoint DNS Resolution with Azure DNS Private Resolver
- How to implement Azure VPN Gateway with P2S VPN connection to mimic on-prem to Azure connectivity

and many more.

Workshop is organized as a combination of theoretical blocks with slides and hand-on labs. Estimated time for workshop completion is between 3 and 4 hours.

## Agenda

- Welcome + practical information
- Azure Azure Private Link overview - slides can be found [here](../slides/private-links.pptx)
- [Lab-01](labs/lab-01/index.md) - Provision lab resources
- [Lab-02](labs/lab-02/index.md) - Create a private endpoint for Azure SQL using Azure Portal
- [Lab-03](labs/lab-03/index.md) - Create a private endpoint for Azure KeyVault using Bicep
- [Lab-04](labs/lab-04/index.md) - Deploy Private DNS Resolver using Bicep
- [Lab-05](labs/lab-05/index.md) - Use Azure Policy to Create DNS Records for Private Endpoints
- [Lab-06](labs/lab-06/index.md) - Network Security Groups support for Private Endpoints
- [Lab-07](labs/lab-07/index.md) - cleaning up resources


## Prerequisites

Please spend some time before the workshop and make sure that you have installed/registered/configured all [prerequisites](./prerequisites.md).
# lab-07 - cleaning up resources

This is the most important part of the workshop. We need to clean up all resources that we provisioned during the workshop to avoid unexpected bills.

## Task #1 - delete lab infrastructure

Remove all resources that were created during the workshop by running the following command:

```powershell
az group delete --name iac-ws5-rg --yes
```

## Task #2 - delete Policy definition

```powershell	
Remove-AzPolicyDefinition -Name 'deploy-sa-blob-ple-dns-records'
```

## Task #3 - delete Azure AD group for SQL Admins

```powershell
az ad group delete -g iac-ws5-sql-administrators
```
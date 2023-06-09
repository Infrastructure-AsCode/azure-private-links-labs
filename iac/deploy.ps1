$stopwatch = [System.Diagnostics.Stopwatch]::new()
$stopwatch.Start()

$location = 'westeurope'

$sqlAdminsAdGroupName = 'iac-ws5-sql-administrators'
# create Azure AD group for SQL Server administrators
Write-Host "Creating Azure AD group iac-ws5-sql-administrators for SQL Server administrators..."
$sqlAdminsGroupObjectId = (az ad group create --display-name $sqlAdminsAdGroupName --mail-nickname $sqlAdminsAdGroupName --query id -o tsv)

# Get signed in user object id
Write-Host "Getting signed-in user object id..."
$signedIdUserObjectId = (az ad signed-in-user show --query id -otsv)

# Add your user account to iac-ws5-sql-administrators group
Write-Host "Adding user $signedIdUserObjectId into $sqlAdminsAdGroupName group..."
az ad group member add -g $sqlAdminsAdGroupName --member-id $signedIdUserObjectId --only-show-errors

# Get your external public IP address
$homeIP = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()
Write-Host "Your external public IP address is $homeIP. It will be used for SQL Server firewall rule."

Write-Host "Deploying workshop lab infra into $location..."
$deploymentName = 'iac-ws5-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
az deployment sub create -l $location --template-file infra.bicep `
    -p location=$location `
    -p signedInUserId=$signedIdUserObjectId `
    -p sqlAdminsGroupName=$sqlAdminsAdGroupName `
    -p sqlAdminsGroupObjectId=$sqlAdminsGroupObjectId `
    -p homeIP=$homeIP `
    -n $deploymentName

$stopwatch.Stop()

Write-Host "Deployment time: " $stopwatch.Elapsed 

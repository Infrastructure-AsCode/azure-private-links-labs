$stopwatch = [System.Diagnostics.Stopwatch]::new()
$stopwatch.Start()

$location = 'westeurope'

# Get signed in user object id
Write-Host "Getting signed-in user object id..."
$signedIdUserObjectId = (az ad signed-in-user show --query id -otsv)

# Get SQL Admin Azure AG Group object id
$sqlAdminsAdGroupName = 'iac-ws5-sql-administrators'
Write-Host "Getting $sqlAdminsAdGroupName AD group object id..."
$sqlAdminsGroupObjectId = (az ad group show -g $sqlAdminsAdGroupName --query id -otsv)

Write-Host "Deploying workshop lab infra into $location..."
$deploymentName = 'iac-ws5-{0}' -f (-join (Get-Date -Format 'yyyyMMddTHHMMssffffZ')[0..63])
az deployment sub create -l $location --template-file infra.bicep `
    -p location=$location `
    -p signedInUserId=$signedIdUserObjectId `
    -p sqlAdminsGroupName=$sqlAdminsAdGroupName `
    -p sqlAdminsGroupObjectId=$sqlAdminsGroupObjectId `
    -n $deploymentName

$stopwatch.Stop()

Write-Host "Deployment time: " $stopwatch.Elapsed 

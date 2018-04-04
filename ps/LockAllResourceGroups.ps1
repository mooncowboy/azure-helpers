
# Get List of RGs with NoDelete locks
$rgLocked = Get-AzureRmResourceLock | Where-Object { $_.Properties.level -eq "CanNotDelete" -and $_.ResourceType -eq "Microsoft.Authorization/locks" } | select -ExpandProperty ResourceGroupName

Write-Host "`nFound CanNotDelete locks in the following RGs:`n"
Foreach($name in $rgLocked)
{
Write-Host $name
# Remove-AzureRmResourceGroup -Name $name.ResourceGroupName -Verbose -Force
}

Write-Host "-----------------------------------------------------------------------------`n"

# Get other RGs
$rgName = Get-AzureRmResourceGroup | Where-Object { $rgLocked -notcontains $_.ResourceGroupName }

Write-Host "Adding CanNotDelete locks to the following RGs:`n"
Foreach($name in $rgName)
{
 Write-Host $name.ResourceGroupName
 New-AzureRmResourceLock -LockName "NoDelete" -LockLevel CanNotDelete -LockNotes "Added via PowerShell script" -ResourceGroupName $name.ResourceGroupName  -Force -Verbose

}
Write-Host "---------------------------------- DONE -------------------------------------"
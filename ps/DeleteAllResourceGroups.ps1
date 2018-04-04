
# Caution - This will remove all Resource Groups without CanNotDelete locks

$rgName = Get-AzureRmResourceGroup

Foreach($name in $rgName)
{
Write-Host $name.ResourceGroupName
Remove-AzureRmResourceGroup -Name $name.ResourceGroupName -Verbose -Force
}
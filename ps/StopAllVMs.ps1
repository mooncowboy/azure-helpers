# Authentication block from https://sanganakauthority.blogspot.com/2017/05/run-login-azurermaccount-to-login.html
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName      
    "Logging in to Azure..."
    $account = Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
Write-Output $account
# end auth block

$vmList = Get-AzureRmVM | Where-Object { $_.Tags.ContainsKey('NoShutdown') -eq $false }
$stoppedVMs = @()

foreach($vmInfo in $vmList) {
    $vm = Get-AzureRmVM -ResourceGroupName $vmInfo.ResourceGroupName -Name $vmInfo.Name -Status
    $isDeallocated = ($vm.Statuses | where Code -Like 'PowerState/*').Code -eq "PowerState/deallocated"

    "Checking " + $vm.Name + ", isDeallocated=" + $isDeallocated

    if(!$isDeallocated) { 
        $vm | Stop-AzureRmVM -Force
        $stoppedVMs += $vm
    }
}

$stoppedVMs | select Name, ResourceGroupName
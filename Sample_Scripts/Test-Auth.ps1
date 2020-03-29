If ((Get-Command Get-AutomationConnection -ErrorAction SilentlyContinue)) {
    $AzureAutomation = $true

        Write-Output "Found Azure Automation commands, checking for Azure RunAs Connection..."
        # Attempts to use the Azure Run As Connection for automation
        $svcPrncpl = Get-AutomationConnection -Name "AzureRunAsConnection"
        $svcPrncpl
        $tenantId = $svcPrncpl.tenantId
        Write-Output "tenantId"
        $tenantId
        $appId = $svcPrncpl.ApplicationId
        Write-Output "appId"
        $appId 
        $crtThmprnt = $svcPrncpl.CertificateThumbprint
        Write-Output "crtThmprnt"
        $crtThmprnt
        Connect-AzAccount -ServicePrincipal -TenantId $tenantId -ApplicationId $appId -CertificateThumbprint $crtThmprnt 
}
Else {Write-Output ("Azure Automation commands missing, skipping Azure RunAs Connection...")}

$Subs = Get-AzSubscription -Subscriptionid "3ba3ebad-7974-4e80-a019-3a61e0b7fa91"
$Subs
Set-AzContext -SubscriptionId 3ba3ebad-7974-4e80-a019-3a61e0b7fa91 | Out-Null
$RGs = Get-AzResourceGroup -ResourceGroupName "hrwrg"
$RGs

Write-Output "$(Get-Date -Format yyyy-MM-ddTHH.mm.fff) Starting your script..."
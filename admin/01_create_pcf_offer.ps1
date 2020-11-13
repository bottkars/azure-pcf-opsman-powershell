#//Azs.ServiceAdmin
#requires -module Azs.Compute.Admin
#requires -module Azs.Storage.Admin
[CmdletBinding(HelpUri = "https://github.com/bottkars/azurestack-kickstart")]
param (
[Parameter(ParameterSetName = "1", Mandatory = $false,Position = 1)]$offer = "Tanzu_Offer",
$plan = "Tanzu_PLAN",
$rg_name = "plans_and_offers",
$owner = $Global:Service_RM_Account.Context.Account.Id
#$SubscriptionID = $Global:SubscriptionID
)
if (!$Global:SubscriptionID)
{
Write-Warning -Message "You Have not Configured a SubscriptionID, did you run 99_bootstrap.ps1 ?"
break
}
if (!$Global:Service_RM_Account.Context)
    {
    Write-Warning -Message "You are not signed in to your Azure RM Environment as Serviceadmin. Please run .\admin\99_bootstrap.ps1"
    break
    }

try {
    Write-Host -ForegroundColor White -NoNewline "Checking for RG $rg_name"
    $RG=Get-AZResourceGroup -Name $rg_name -Location local -ErrorAction Stop  
}
catch {
    Write-Host -ForegroundColor Red [failed]
    Write-Host -ForegroundColor White -NoNewline "Creating RG $rg_name"        
    $RG = New-AZResourceGroup -Name $rg_name -Location local
}
Write-Host -ForegroundColor Green [Done]
try {
    $AZSOffer = Get-AzsManagedOffer -Name $offer -ResourceGroupName $rg_name -ErrorAction Stop 
}
catch {
      Write-Host "$Offer not found in $rg_name, we need to create it"
}
if  ($AZSOffer)
    {
        Write-Host "Offer with name $offer already exists in $rg_name"
        break
    }
if (!($ComputeQuota = Get-AzsComputeQuota -Name Tanzu-compute))
    {
    $ComputeQuota = New-AzsComputeQuota -Name Tanzu-compute `
    -Location local -VirtualMachineCount 5000 `
    -AvailabilitySetCount 100 -CoresCount 5000 -VmScaleSetCount 10 `
    -PremiumManagedDiskAndSnapshotSize 4096 `
    -StandardManagedDiskAndSnapshotSize 4096  
    }
if (!($NetworkQuota = Get-AzsNetworkQuota -Name Tanzu-network))
    {
    $NetworkQuota = New-AzsNetworkQuota -Name Tanzu-network `
    -Location local -MaxPublicIpsPerSubscription 20 `
    -MaxVNetsPerSubscription 20 `
    -MaxVirtualNetworkGatewaysPerSubscription 20 `
    -MaxVirtualNetworkGatewayConnectionsPerSubscription 1000 -MaxNicsPerSubscription 200
    }


if (!($StorageQuota = Get-AzsStorageQuota -Name Tanzu-storage))
       {
           $StorageQuota = New-AzsStorageQuota -Name Tanzu-storage -Location local `
           -NumberOfStorageAccounts 300 -CapacityInGB 5000
       }


$Tanzu_PLAN = Get-AZSPlan -Name $plan -ResourceGroupName $rg_name -ErrorAction SilentlyContinue
if (!$Tanzu_PLAN) {
        Write-Host "$plan not found in $rg_name, creating now"
        $Tanzu_PLAN = New-AzsPlan -Name $plan -DisplayName "Offer for Tanzu" `
    	    -ResourceGroupName $rg_name `
            -QuotaIds $StorageQuota.Id,$NetworkQuota.Id,$ComputeQuota.Id -Location local
    }


$AZSOffer = New-AzsOffer -Name $offer -DisplayName "Offer for Tanzu / Cloud Foundry" `
 -BasePlanIds $Tanzu_PLAN.Id -State Private -Location local -ResourceGroupName $rg_name
New-AzsUserSubscription -DisplayName "Azure Tanzu Subscription" -Owner $owner -OfferId $AZSOffer.Id #-SubscriptionId $SubscriptionID
Write-Output $AZSOffer
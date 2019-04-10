#requires -module pivposh
param(
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_changed", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_product", Mandatory = $true)]
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_changed", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_product", Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('green', 'blue')]
    $deploymentcolor = "green",


    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [switch]$DO_NOT_APPLY,

    [Parameter(ParameterSetName = "apply_changed", Mandatory = $true)]
    [switch]$APPLY_CHANGED,

    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [switch]$APPLY_ALL
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$downloaddir = $director_conf.downloaddir

# start the opsman deploy


# get current opsman

$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$location = ($director_conf.domain -split '\.')[0]
$domain = $director_conf.domain -replace "$location."
$RG = $director_conf.RG
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN


if ($deploymentcolor='green')
{
    $current_color='blue'
}
else {
    $current_color='green'
}



om --skip-ssl-validation `
    deployed-products


$EXPORT_FILE="$((New-Guid).guid).export"
om --skip-ssl-validation `
    export-installation --output-file $EXPORT_FILE  


Get-AzureRmResource -ResourceGroupName $RG `
-Name *$current_color* `
-ResourceType Microsoft.Compute/virtualMachines | Remove-AzureRmResource -Force


Get-AzureRmResource -ResourceGroupName $RG `
-Name *$current_color* `
-ResourceType Microsoft.Compute/disks | Remove-AzureRmResource -Force



../deploy_pcf-opsman.ps1 -OpsmanUpdate `
 -deploymentcolor $deploymentcolor `
 -dnsdomain $Domain `
 -location $location `
 -resourceGroup $RG `
 -downloadPath $director_conf.downloaddir




om --skip-ssl-validation `
    deployed-products
Pop-Location
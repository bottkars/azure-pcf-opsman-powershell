#requires -module pivposh
param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(Mandatory = $false)]
    [switch]$apply
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$downloaddir = $director_conf.downloaddir
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"

$DEPLOYED_PRODUCTS = om --skip-ssl-validation `
curl `
--silent `
--path /api/v0/deployed/products | ConvertFrom-Json

$DEPLOYED_PRODUCTS

foreach ($PRODUCT_NAME in $DEPLOYED_PRODUCTS)
{
    om --skip-ssl-validation `
    assign-stemcell  `
    --stemcell latest `
    --product $PRODUCT_NAME.type
}

if ($apply.IsPresent){
    Write-Host "Applying Stemcells to Products"
    om --skip-ssl-validation `
        apply-changes `
        --skip-unchanged-products
}

Pop-Location
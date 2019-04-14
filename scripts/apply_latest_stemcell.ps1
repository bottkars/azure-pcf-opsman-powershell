#requires -module pivposh
param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(Mandatory = $false)]
    [switch]$apply
)
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
if ($director_conf.branch)
  {
    $branch = $director_conf.branch
  }
else {
  $branch = "2.5"
}
$OM_Target = $director_conf.OM_TARGET
$downloaddir = $director_conf.downloaddir
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"

$DEPLOYED_PRODUCTS =  om --env $HOME/om_$($RG).env `
curl `
--silent `
--path /api/v0/deployed/products | ConvertFrom-Json

$DEPLOYED_PRODUCTS

foreach ($PRODUCT_NAME in $DEPLOYED_PRODUCTS)
{
     om --env $HOME/om_$($RG).env `
    assign-stemcell  `
    --stemcell latest `
    --product $PRODUCT_NAME.type
}

if ($apply.IsPresent){
    Write-Host "Applying Stemcells to Products"
     om --env $HOME/om_$($RG).env `
        apply-changes `
        --skip-unchanged-products
}

Pop-Location

    
param(
    [Parameter(Mandatory = $true)]
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE
)

Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
# setting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:Path = "$($env:Path);$HOME/OM"
try
{$PRODUCTS=$( om --env $HOME/om_$($director_conf.RG).env `
  deployed-products `
    --format json) | ConvertFrom-Json
}
catch
{
    Write-Host "There was an error"
    Pop-Location
    Break
}
Write-Output $PRODUCTS
Pop-Location
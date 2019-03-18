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
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
try
{
    write-host "getting deployed products"
    $PRODUCTS=$(om --skip-ssl-validation `
    curl --path /api/v0/deployed/products 2>$null | ConvertFrom-Json)
}
catch
{
    Write-Host "There was an error"
    Pop-Location
    Break
}
$PRODUCTS=$DEPLOYED | ForEach-Object {
    Write-Host "getting status for $($_.installation_name) ..."
    (om.exe --skip-ssl-validation `
 curl --path "/api/v0/deployed/products/$($_.installation_name)/status" 2>$null | ConvertFrom-Json).status
} 
Write-Output $PRODUCTS
Pop-Location
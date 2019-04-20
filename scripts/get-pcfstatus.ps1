param(
    [Parameter(Mandatory = $FALSE)]
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE="$HOME/director_pcf.json"
)

Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
# setting the env
$env:Path = "$($env:Path);$HOME/OM"
try
{
    write-host "getting deployed products"
    $DEPLOYED=$(om --env $HOME/om_$($director_conf.RG).env `
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
    (om.exe --env $HOME/om_$($director_conf.RG).env `
 curl --path "/api/v0/deployed/products/$($_.installation_name)/status" 2>$null | ConvertFrom-Json).status
} 
Write-Output $PRODUCTS
Pop-Location
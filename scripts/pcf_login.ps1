param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [switch]$showcreds
)
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"

$PCF_API = "api.sys.$($director_conf.PCF_SUBDOMAIN_NAME).$($director_conf.domain)"
<#
$BOSH_CREDENTIALS= om --skip-ssl-validation `
    curl `
      --silent `
      --path /api/v0/deployed/director/credentials/bosh_commandline_credentials
#>
if (!(get-command cf.exe -ErrorAction SilentlyContinue)){
    install-script install-cf-cli
    install-cf-cli.ps1
}
Write-Host "Reading deployed Products from OpsManager" 
$DEPLOYED_PRODUCTS = om --skip-ssl-validation `
    curl `
    --silent `
    --path /api/v0/deployed/products | ConvertFrom-Json



$PCF = $DEPLOYED_PRODUCTS | Select-Object | where type -eq cf      
Write-Host "Getting cf Credentials from OpsManger"
$PCF_ADMIN_USER = om --skip-ssl-validation `
    curl `
    --silent `
    --path "/api/v0/deployed/products/$($PCF.GUID)/credentials/.uaa.admin_credentials" `
    | ConvertFrom-Json

if ($showcreds.IsPresent) {
    Write-Host $PCF_ADMIN_USER.credential.value.identity
    Write-Host $PCF_ADMIN_USER.credential.value.password
}
else {
cf login --skip-ssl-validation `
    -u $PCF_ADMIN_USER.credential.value.identity `
    -p $PCF_ADMIN_USER.credential.value.password `
    -a $PCF_API
}
param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [switch]$showcreds
)
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:Path = "$($env:Path);$HOME/OM"

$PCF_API = "api.sys.$($director_conf.PCF_SUBDOMAIN_NAME).$($director_conf.domain)"
<#
$BOSH_CREDENTIALS=  om --env $HOME/om_$($director_conf.RG).env `
    curl `
      --silent `
      --path /api/v0/deployed/director/credentials/bosh_commandline_credentials
#>

try {
    get-command cf.exe -ErrorAction SilentlyContinue
}
catch {
    install-script install-cf-cli -MinimumVersion 1.6 -Scope CurrentUser -Force
    install-cf-cli.ps1 -CLIRelease '6.43.0' -DownloadDir $HOME/Downloads
}
Write-Host "Reading deployed Products from OpsManager" 
$DEPLOYED_PRODUCTS =  om --env $HOME/om_$($director_conf.RG).env `
    curl `
    --silent `
    --path /api/v0/deployed/products | ConvertFrom-Json



$PCF = $DEPLOYED_PRODUCTS | Select-Object | where-object type -eq cf      
Write-Host "Getting cf Credentials from OpsManger"
$PCF_ADMIN_USER =  om --env $HOME/om_$($director_conf.RG).env `
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
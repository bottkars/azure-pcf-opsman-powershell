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
$UAA_API = "uaa.sys.$($director_conf.PCF_SUBDOMAIN_NAME).$($director_conf.domain)"

Write-Host "Reading deployed Products from OpsManager" 
$DEPLOYED_PRODUCTS = om --skip-ssl-validation `
    curl `
    --silent `
    --path /api/v0/deployed/products | ConvertFrom-Json

$PCF = $DEPLOYED_PRODUCTS | Select-Object | where-object type -eq cf      
Write-Host "Getting UAA from OpsManger"
$UAA_ADMIN_USER = om --skip-ssl-validation `
    curl `
    --silent `
    --path "/api/v0/deployed/products/$($PCF.GUID)/credentials/.uaa.admin_client_credentials" `
    | ConvertFrom-Json

if ($showcreds.IsPresent) {
    Write-Host $UAA_ADMIN_USER.credential.value.identity
    Write-Host $UAA_ADMIN_USER.credential.value.password
}
else {
    uaac target $UAA_API --skip-ssl-validation
    uaac token client get admin -s $UAA_ADMIN_USER.credential.value.password 
}
#requires -module pivposh
param(
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [switch]$DO_NOT_APPLY,
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [switch]$APPLY_ALL,    
    [Parameter(ParameterSetName = "applyme", Mandatory = $true)]
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
if ($director_conf.release)
  {
    $release = $director_conf.release
  }
else {
  $release = "release"
}
$downloaddir = $director_conf.downloaddir
$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$domain = $director_conf.domain

$OM_Target = $director_conf.OM_TARGET
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$GLOBAL_RECIPIENT_EMAIL = $env_vars.PCF_NOTIFICATIONS_EMAIL
$wavefront_url = $env_vars.wavefront_url
$Wavefront_token = $env_vars.wavefront_token
if (!$wavefront_url -or !$wavefront_url)
{
    Write-Host "please ad wavefront_url and wavefron_token to your env.json"
}

$PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
if (!(get-command uaac -ErrorAction SilentlyContinue )) {
    install-script install-cf-uaac -force -Scope CurrentUser
    install-cf-uaac.ps1
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}
.$PSScriptRoot/uaa_login.ps1 -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE
$users = uaac curl -k /Users  | Select-String "RESPONSE BODY:" -Context 0, 10000000
$Userlist = ($USERS -replace "RESPONSE BODY:" -replace ">" |  ConvertFrom-Json).resources

$Wavefront_user = ($Userlist | where-object userName -match wavefront-nozzle)

if ( !$Wavefront_user ) {
    Write-Host "Creating user wavefront-nozzle"
    uaac -t user add wavefront-nozzle --password $PIVNET_UAA_TOKEN --emails $GLOBAL_RECIPIENT_EMAIL | out-null
    uaac -t member add cloud_controller.admin_read_only wavefront-nozzle | out-null
    uaac -t member add doppler.firehose wavefront-nozzle | out-null
}
else {
    Write-Host "User wavefront-nozzle already exists"
}
uaac user get wavefront-nozzle
"
product_name: wavefront-nozzle
pcf_pas_network: pcf-pas-subnet
wavefront_url: $wavefront_url
wavefront_token: $wavefront_token
wavefront_proxy: $($director_conf.PCF_SUBDOMAIN_NAME)
api_hostname: api.sys.$($director_conf.PCF_SUBDOMAIN_NAME).$($director_conf.domain)
uaa_user: wavefront_nozzle
uaa_password: $PIVNET_UAA_TOKEN
tag_foundation: $($director_conf.PCF_SUBDOMAIN_NAME)
" | Set-Content $HOME/wavefront-nozzle_vars.yaml
.$PSScriptRoot/deploy_tile.ps1 -tile wavefront-nozzle -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE

Pop-Location 
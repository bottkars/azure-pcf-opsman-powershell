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
$MySelf=$($MyInvocation.MyCommand)
$MySelf=$MySelf -replace ".ps1"
$SELF_TILE = $MySelf -replace "deploy_"
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$smtp_address = $env_vars.SMTP_ADDRESS
$smtp_identity = $env_vars.SMTP_IDENTITY
$smtp_password = $env_vars.SMTP_PASSWORD
$smtp_from = $env_vars.SMTP_FROM
$smtp_port = $env_vars.SMTP_PORT

"
product_name: p-event-alerts
pcf_pas_network: pcf-pas-subnet
smtp_address: $smtp_address
smtp_identity: $smtp_identity
smtp_password: `"$smtp_password`"
smtp_from: $smtp_from
smtp_port: $smtp_port
" | Set-Content "$HOME/$($SELF_TILE)_vars.yaml"


switch ($PsCmdlet.ParameterSetName) { 
    "apply_all" { 
        .$PSScriptRoot/deploy_tile.ps1 -tile $SELF_TILE -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -APPLY_ALL
    } 
    "no_apply" { 
        .$PSScriptRoot/deploy_tile.ps1 -tile $SELF_TILE -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -DO_NOT_Apply
    } 
    default {
        .$PSScriptRoot/deploy_tile.ps1 -tile $SELF_TILE -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE
    }
} 

Pop-Location 
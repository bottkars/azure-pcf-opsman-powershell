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
if ($director_conf.branch)
  {
    $branch = $director_conf.branch
  }
else {
  $branch = "2.4"
}
$downloaddir = $director_conf.downloaddir
$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$domain = $director_conf.domain


"
product_name: scanner
pcf_pas_network: pcf-pas-subnet
" | Set-Content $HOME/p-compliance-scanner_vars.yaml


switch ($PsCmdlet.ParameterSetName) { 
    "apply_all" { 
        .$PSScriptRoot/deploy_tile.ps1 -tile p-compliance-scanner -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -APPLY_ALL
    } 
    "no_apply" { 
        .$PSScriptRoot/deploy_tile.ps1 -tile p-compliance-scanner -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -DO_NOT_Apply
    } 
    default {
        .$PSScriptRoot/deploy_tile.ps1 -tile p-compliance-scanner -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE
    }
} 

Pop-Location 
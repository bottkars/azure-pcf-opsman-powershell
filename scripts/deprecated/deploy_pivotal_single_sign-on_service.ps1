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
"
product_name: Pivotal_Single_Sign-On_Service
pcf_pas_network: pcf-pas-subnet
" | Set-Content $HOME/pivotal_single_sign-on_service_vars.yaml
.$PSScriptRoot/deploy_tile.ps1 -tile pivotal_single_sign-on_service -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE

Pop-Location 
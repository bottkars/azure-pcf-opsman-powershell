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
$env = Get-Content $HOME/env.json | ConvertFrom-Json
$MySelf = $MyInvocation.MyCommand
Write-Verbose $MySelf
$PivSlug = $MySelf -replace ".ps1" -replace "deploy_"

"
product_name: $($PivSlug)
pcf_pas_network: pcf-pas-subnet
secret_key: $($env.PCF_PIVNET_UAA_TOKEN)
" | Set-Content "$HOME/$($PivSlug)_vars.yaml"





switch ($PsCmdlet.ParameterSetName) { 
    "apply_all" { 
        .$PSScriptRoot/deploy_tile.ps1 -tile $($PivSlug) -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -APPLY_ALL -update_stemcells
    } 
    "no_apply" { 
        .$PSScriptRoot/deploy_tile.ps1 -tile $($PivSlug) -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -DO_NOT_Apply -update_stemcells
    } 
    default {
        .$PSScriptRoot/deploy_tile.ps1 -tile $($PivSlug) -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -update_stemcells
    
    }
} 

if (!$DO_NOT_APPLY.IsPresent)
{
    $deployed =  om --env $HOME/om_$($RG).env `
    curl --path /api/v0/staged/products 2>$null | ConvertFrom-Json
    $MINIO_LB_IP = ((om.exe --skip-ssl-validation `
        curl --path "/api/v0/deployed/products/$(($deployed | where-object type -eq minio-internal-blobstore).Installation_Name)/status" 2>$null `
    | ConvertFrom-Json).status  | Where-Object job-name -Match load-balancer).ips 
    
    "
    minio_ip: $($MINIO_LB_IP)
    " | Set-Content "$HOME/$($PivSlug)_pas_vars.yaml"

}


Pop-Location 
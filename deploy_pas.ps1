#requires -module pivposh
param(
# set to true if downloading 
[Parameter(Mandatory=$false)]
[switch]$no_product_download
)
$env:OM_Password = "Password123!"
$env:OM_Target = "pcfopsmangreen.local.cloudapp.azurestack.external"
$env:OM_Username = "opsman"
$env:Path = "$($env:Path);$HOME/OM"
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "elastic_runtime"
$PCF_PAS_VERSION = "2.3.5"
$downloaddir = "E:\"
$product_kind = "cf"

Write-Host "Getting Release for $product_kind $PCF_PAS_VERSION"
$piv_release = Get-PIVRelease -id elastic-runtime | where version -Match $PCF_PAS_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $product_kind $PCF_PAS_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$product_kind*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($product_kind)_$($PCF_PAS_VERSION)" -Force

if (!($no_product_download.ispresent)) {
    om --skip-ssl-validation `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug elastic-runtime `
        --product-version $PCF_PAS_VERSION `
        --stemcell-iaas azure `
        --download-stemcell `
        --output-directory  "$($output_directory.FullName)"

}





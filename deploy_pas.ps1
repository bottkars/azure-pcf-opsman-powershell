#requires -module pivposh

$env:OM_Password = "Password123!"
$env:OM_Target = "pcfopsmangreen.local.cloudapp.azurestack.external"
$env:OM_Username = "opsman"
$env:Path = "$($env:Path);$HOME/OM"
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "elastic_runtime"
$PCF_PAS_VERSION = "2.4.1"
$downloaddir = "E:\"
$product_kind = "cf"
[switch]$download_product = $true

$piv_release = Get-PIVRelease -id elastic-runtime | where version -Match $PCF_PAS_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
$piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | where aws_object_key -Like *$product_kind*.pivotal*

if ($download_product.ispresent) {
    $output_directory = New-Item -ItemType Directory $downloaddir/$PCF_PAS_VERSION -Force
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



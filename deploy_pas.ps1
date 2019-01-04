#requires -module pivposh
param(
# PAS Version
[Parameter(Mandatory=$false)][ValidateSet('2.4.0','2.4.1','2.3.5')]
$PCF_PAS_VERSION = "2.3.5",
# PAS Type ( srt for small runtime, cf for full pas)
[Parameter(Mandatory=$false)][ValidateSet('srt','cf')]
$PRODUCT_NAME = "cf",
$OM_Pass = "Password123!",
$OM_Username = "opsman",
$OM_Target = "pcfopsmangreen.local.cloudapp.azurestack.external",
# set to true if downloading 
[Parameter(Mandatory=$false)]
[switch]$no_product_download,
$downloaddir = "$HOME/downloads"
)
$env:OM_Password = $OM_Pass
$env:OM_Username = $OM_Username
$env:OM_Target = $OM_Target

$env:Path = "$($env:Path);$HOME/OM"
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "elastic_runtime"




Write-Host "Getting Release for $PRODUCT_NAME $PCF_PAS_VERSION"
$piv_release = Get-PIVRelease -id elastic-runtime | where version -Match $PCF_PAS_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $PRODUCT_NAME $PCF_PAS_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$PRODUCT_NAME*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($PRODUCT_NAME)_$($PCF_PAS_VERSION)" -Force

if (!($no_product_download.ispresent)) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"

    om --skip-ssl-validation `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug elastic-runtime `
        --product-version $PCF_PAS_VERSION `
        --stemcell-iaas azure `
        --download-stemcell `
        --output-directory  "$($output_directory.FullName)"

}

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME=$download_file.product_path
$STEMCELL_FILENAME=$download_file.stemcell_path


Write-Host "importing $STEMCELL_FILENAME into OpsManager"
# Import the tile to Ops Manager.
om --skip-ssl-validation `
  --request-timeout 3600 `
  upload-product `
  --product $TARGET_FILENAME


$PRODUCTS=$(om --skip-ssl-validation `
  available-products `
    --format json) | ConvertFrom-Json
# next lines for compliance to bash code
$VERSION= $PRODUCTS.version
$PRODUCT_NAME=$PRODUCTS.name
  # 2.  Stage using om cli

  om --skip-ssl-validation `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION


"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet `
pcf_system_domain: system.pcfdemo.local.azurestack.external `
pcf_apps_domain: system.pcfdemo.local.azurestack.external `
pcf_notifications_email: email@examle.com `
pcf_cert_pem: `"${PCF_CERT_PEM}`"
pcf_key_pem: `"${PCF_KEY_PEM}`"
pcf_credhub_key: `"012345678901234567890`"
pcf_diego_ssh_lb: diegossh-lb
pcf_mysql_lb: mysql-lb
pcf_web_lb: pcf-lb
" | Set-Content $HOME/vars.yaml

om --skip-ssl-validation `
  configure-product `
  -c pas.yaml -l $HOME/vars.yaml
#requires -module pivposh
Push-Location $PSScriptRoot
if (!(Test-Path $PRODUCT_FILE))
{$PRODUCT_FILE = "../examples/rabbitmq.json"}
$rabbitmq_conf = Get-Content $PRODUCT_FILE| ConvertFrom-Json
$director_conf = Get-Content "$($HOME)/director.json" | ConvertFrom-Json
$PCF_RABBITMQ_VERSION = $rabbitmq_conf.PCF_RABBITMQ_VERSION
#$RABBITMQ_STORAGE_KEY = $director_conf.rabbitmq_storage_key
#$RABBITMQ_STORAGEACCOUNTNAME = $director_conf.rabbitmqstorageaccountname

[switch]$force_product_download = [System.Convert]::ToBoolean($director_conf.force_product_download)
$downloaddir = $director_conf.downloaddir
$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$domain = $director_conf.domain

$config_file = $rabbitmq_conf.CONFIG_FILE
$OM_Target = $director_conf.OM_TARGET
# setiing the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$GLOBAL_RECIPIENT_EMAIL = $env_vars.PCF_NOTIFICATIONS_EMAIL

$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "p-rabbitmq"

Write-Host "Getting Release for $slug_id $PCF_RABBITMQ_VERSION"
$piv_release = Get-PIVRelease -id $slug_id | where version -Match $PCF_RABBITMQ_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $PCF_RABBITMQ_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$slug_id*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($slug_id)_$($PCF_RABBITMQ_VERSION)" -Force

if (($force_product_download.ispresent) -or (!(test-path "$($output_directory.FullName)/download-file.json"))) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"

    om --skip-ssl-validation `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug $slug_id `
        --product-version $PCF_RABBITMQ_VERSION `
        --stemcell-iaas azure `
        --download-stemcell `
        --output-directory  "$($output_directory.FullName)"
}

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME=$download_file.product_path
$STEMCELL_FILENAME=$download_file.stemcell_path


Write-Host "importing $TARGET_FILENAME into OpsManager"
# Import the tile to Ops Manager.
om --skip-ssl-validation `
  --request-timeout 3600 `
  upload-product `
  --product $TARGET_FILENAME
Write-Host "importing $STEMCELL_FILENAME into OpsManager"  
om --skip-ssl-validation `
  upload-stemcell `
  --stemcell $STEMCELL_FILENAME

$PRODUCTS=$(om --skip-ssl-validation `
  available-products `
    --format json) | ConvertFrom-Json
# next lines for compliance to bash code
$PRODUCT=$PRODUCTS| where name -Match $slug_id
$PRODUCT_NAME=$PRODUCT.name
$VERSION=$PRODUCT.version

om --skip-ssl-validation `
  deployed-products
  # 2.  Stage using om cli

  om --skip-ssl-validation `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION



"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet `
pcf_service_network: pcf-services-subnet `
server_admin_password: $PCF_PIVNET_UAA_TOKEN 
" | Set-Content $HOME/rabbitmq_vars.yaml

om --skip-ssl-validation `
  configure-product `
  -c "$config_file" -l "$HOME/rabbitmq_vars.yaml"

om --skip-ssl-validation `
  apply-changes

om --skip-ssl-validation `
  deployed-products  
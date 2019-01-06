#requires -module pivposh

$mysql_conf = Get-Content "$($HOME)/mysql.json" | ConvertFrom-Json
$director_conf = Get-Content "$($HOME)/director.json" | ConvertFrom-Json
$PCF_MYSQL_VERSION = $mysql_conf.PCF_MYQL_VERSION
$PRODUCT_NAME = $mysql_conf.PRODUCT_NAME
$MYSQL_STORAGE_KEY = $director_conf.mysql_storage_key
$MYSQL_STORAGEACCOUNTNAME = $director_conf.mysqlstorageaccountname

$OM_Target = $mysql_conf.OM_TARGET
[switch]$no_product_download = [System.Convert]::ToBoolean($mysql_conf.no_product_download)
$downloaddir = $mysql_conf.downloaddir
$PCF_SUBDOMAIN_NAME = $mysql_conf.PCF_SUBDOMAIN_NAME
$domain = $mysql_conf.domain
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$GLOBAL_RECIPIENT_EMAIL = $env_vars.PCF_NOTIFICATIONS_EMAIL

$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "pivotal-mysql"




Write-Host "Getting Release for $slug_id $PCF_MYSQL_VERSION"
$piv_release = Get-PIVRelease -id $slug_id | where version -Match $PCF_MYSQL_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $PCF_MYSQL_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$slug_id*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($slug_id)_$($PCF_MYSQL_VERSION)" -Force

if (!($no_product_download.ispresent)) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"

    om --skip-ssl-validation `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug $slug_id `
        --product-version $PCF_MYSQL_VERSION `
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
  # 2.  Stage using om cli

  om --skip-ssl-validation `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION


$PCF_KEY_PEM=get-content ./pcfdemo.local.azurestack.external.key
$PCF_KEY_PEM=$PCF_KEY_PEM  -join "\r\n"
$PCF_CERT_PEM=get-content ./pcfdemo.local.azurestack.external.cert
$PCF_CERT_PEM=$PCF_CERT_PEM  -join "\r\n"
    

"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet `
pcf_service_network: pcf-services-subnet `
azure.storage_access_key: $MYSQL_STORAGE_KEY
azure.account: $MYSQL_STORAGEACCOUNTNAME
pcf_system_domain: system.pcfdemo.local.azurestack.external `
pcf_apps_domain: system.pcfdemo.local.azurestack.external `
global_recipient_email: $GLOBAL_RECIPIENT_EMAIL `
" | Set-Content $HOME/mysql_vars.yaml

om --skip-ssl-validation `
  configure-product `
  -c ./templates/mysql.yaml -l "$HOME/mysql_vars.yaml"

om --skip-ssl-validation `
  apply-changes
#>
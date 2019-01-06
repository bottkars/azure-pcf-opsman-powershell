#requires -module pivposh
$pas_conf = Get-Content "$($HOME)/pas.json" | ConvertFrom-Json
$director_conf = Get-Content "$($HOME)/director.json" | ConvertFrom-Json
$PCF_PAS_VERSION = $pas_conf.PCF_PAS_VERSION
$PRODUCT_NAME = $pas_conf.PRODUCT_NAME
$OM_Target = $director_conf.OM_TARGET
[switch]$force_product_download = [System.Convert]::ToBoolean($director_conf.force_product_download)
$downloaddir = $pas_conf.downloaddir
$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$domain = $director_conf.domain
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$smtp_address=$env_vars.SMTP_ADDRESS
$smtp_identity=$env_vars.SMTP_IDENTITY
$smtp_password=$env_vars.SMTP_PASSWORD
$smtp_from=$env_vars.SMTP_FROM
$smtp_port=$env_vars.SMTP_PORT
$pcf_notifications_email=$env_vars.PCF_NOTIFICATIONS_EMAIL



$slug_id = "elastic_runtime"

Write-Host "Getting Release for $PRODUCT_NAME $PCF_PAS_VERSION"
$piv_release = Get-PIVRelease -id elastic-runtime | where version -Match $PCF_PAS_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $PRODUCT_NAME $PCF_PAS_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$PRODUCT_NAME*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($PRODUCT_NAME)_$($PCF_PAS_VERSION)" -Force

if (($force_product_download.ispresent) -or (!(Test-Path "$($output_directory.FullName)/download-file.json"))) {
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

om --skip-ssl-validation `
deployed-products

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
$VERSION= $PRODUCTS.version
$PRODUCT_NAME=$PRODUCTS.name
  # 2.  Stage using om cli

  om --skip-ssl-validation `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION


$PCF_KEY_PEM=get-content "$HOME/pcfdemo.local.azurestack.external.key"
$PCF_KEY_PEM=$PCF_KEY_PEM  -join "\r\n"
$PCF_CERT_PEM=get-content "$HOME/pcfdemo.local.azurestack.external.cert"
$PCF_CERT_PEM=$PCF_CERT_PEM  -join "\r\n"
    

"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet `
pcf_system_domain: system.$PCF_SUBDOMAIN_NAME.$domain `
pcf_apps_domain: apps.$PCF_SUBDOMAIN_NAME.$domain `
pcf_cert_pem: `"$PCF_CERT_PEM`"
pcf_key_pem: `"$PCF_KEY_PEM`"
pcf_credhub_key: `"012345678901234567890`"
pcf_diego_ssh_lb: diegossh-lb
pcf_mysql_lb: mysql-lb
pcf_web_lb: pcf-lb
smtp_address: $smtp_address
smtp_identity: $smtp_identity
smtp_password: `"$smtp_password`"
smtp_from: $smtp_from
smtp_port: $smtp_port
pcf_notifications_email: $pcf_notifications_email
" | Set-Content $HOME/vars.yaml

om --skip-ssl-validation `
  configure-product `
  -c $PSScriptRoot/pas.yaml -l $HOME/vars.yaml

om --skip-ssl-validation `
  apply-changes

om --skip-ssl-validation `
  deployed-products
#requires -module pivposh
param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(Mandatory = $false)]	
    [switch]$DO_NOT_APPLY,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('cf', 'srt')]
    $PRODUCT_NAME = "srt",
    $compute_instances = 1
)
Push-Location $PSScriptRoot
$PRODUCT_FILE = "$($HOME)/pas_$($PRODUCT_NAME).json"
if (!(Test-Path $PRODUCT_FILE))
{$PRODUCT_FILE = "../examples/pas_$($PRODUCT_NAME).json"}
$pas_conf = Get-Content $PRODUCT_FILE | ConvertFrom-Json
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$PCF_PAS_VERSION = $pas_conf.PCF_PAS_VERSION
$config_file = $pas_conf.CONFIG_FILE
$OM_Target = $director_conf.OM_TARGET
[switch]$force_product_download = [System.Convert]::ToBoolean($director_conf.force_product_download)
$downloaddir = $director_conf.downloaddir
$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$domain = $director_conf.domain
$RG = $director_conf.RG
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$smtp_address = $env_vars.SMTP_ADDRESS
$smtp_identity = $env_vars.SMTP_IDENTITY
$smtp_password = $env_vars.SMTP_PASSWORD
$smtp_from = $env_vars.SMTP_FROM
$smtp_port = $env_vars.SMTP_PORT
$pcf_notifications_email = $env_vars.PCF_NOTIFICATIONS_EMAIL
$PCF_DOMAIN_NAME = $domain



$slug_id = "elastic_runtime"



Write-Host "Getting Release for $PRODUCT_NAME $PCF_PAS_VERSION"
$piv_release = Get-PIVRelease -id elastic-runtime | where version -Match $PCF_PAS_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $PRODUCT_NAME $PCF_PAS_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$PRODUCT_NAME*.pivotal*
write-host


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
        --output-directory  "$($output_directory.FullName)"

}

if ($LASTEXITCODE -ne 0) {
    write-Host  "Error running om, please fix"
    Pop-Location
    break
}


$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME = $download_file.product_path

om --skip-ssl-validation `
    deployed-products

Write-Host "importing $TARGET_FILENAME into OpsManager"
# Import the tile to Ops Manager.
om --skip-ssl-validation `
    --request-timeout 3600 `
    upload-product `
    --product $TARGET_FILENAME
if ($LASTEXITCODE -ne 0) {
    write-Host  "Error running om, please fix and retry"
    Pop-Location
    break
}


$PRODUCTS = $(om --skip-ssl-validation `
        available-products `
        --format json) | ConvertFrom-Json
# next lines for compliance to bash code
$VERSION = $PRODUCTS.version
$PRODUCT_NAME = $PRODUCTS.name
# 2.  Stage using om cli

om --skip-ssl-validation `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION

om --skip-ssl-validation `
    assign-stemcell  `
    --stemcell latest `
    --product $PRODUCT_NAME



$PCF_KEY_PEM = get-content "$($HOME)/$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME).key"
$PCF_KEY_PEM = $PCF_KEY_PEM -join "\r\n"
$PCF_CERT_PEM = get-content "$($HOME)/$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME).crt"
$PCF_CERT_PEM = $PCF_CERT_PEM -join "\r\n"
    

"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet `
pcf_system_domain: sys.$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME `
pcf_apps_domain: apps.$PCF_SUBDOMAIN_NAME.$PCF_DOMAIN_NAME `
pcf_cert_pem: `"$PCF_CERT_PEM`"
pcf_key_pem: `"$PCF_KEY_PEM`"
pcf_credhub_key: `"012345678901234567890`"
pcf_diego_ssh_lb: $RG-diego-ssh-lb
pcf_mysql_lb: $RG-mysql-lb
pcf_web_lb: $RG-web-lb
pcf_tcp_lb: $RG-tcp-lb
smtp_address: $smtp_address
smtp_identity: $smtp_identity
smtp_password: `"$smtp_password`"
smtp_from: $smtp_from
smtp_port: $smtp_port
pcf_notifications_email: $pcf_notifications_email
compute_instances: $compute_instances
" | Set-Content $HOME/vars.yaml

om --skip-ssl-validation `
    configure-product `
    -c "$config_file" -l $HOME/vars.yaml
if ($LASTEXITCODE -ne 0) {
    write-Host  "Error running om, please fix and retry"
    Pop-Location
    break
}
om --skip-ssl-validation `
    apply-changes

om --skip-ssl-validation `
    deployed-products
Pop-Location
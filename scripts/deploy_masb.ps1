#requires -module pivposh
param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [switch]$do_not_apply
)
Push-Location $PSScriptRoot
$PRODUCT_FILE = "$($HOME)/masb.json"
if (!(Test-Path $PRODUCT_FILE))
{$PRODUCT_FILE = "../examples/masb.json"}
$masb_conf = Get-Content $PRODUCT_FILE| ConvertFrom-Json
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$PCF_masb_VERSION = $masb_conf.PCF_masb_VERSION

[switch]$force_product_download = [System.Convert]::ToBoolean($director_conf.force_product_download)
$downloaddir = $director_conf.downloaddir
$PCF_SUBDOMAIN_NAME = $director_conf.PCF_SUBDOMAIN_NAME
$domain = $director_conf.domain
# getting the env


$config_file = $masb_conf.CONFIG_FILE
$OM_Target = $director_conf.OM_TARGET
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$GLOBAL_RECIPIENT_EMAIL = $env_vars.PCF_NOTIFICATIONS_EMAIL

$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "azure-service-broker"
##
$AZURE_SUBSCRIPTION_ID = $env_vars.AZURE_SUBSCRIPTION_ID
$AZURE_TENANT_ID = $env_vars.AZURE_TENANT_ID
$AZURE_CLIENT_ID = $env_vars.AZURE_CLIENT_ID
$AZURE_CLIENT_SECRET = $env_vars.AZURE_CLIENT_SECRET
$ENV_SHORT_NAME = $PCF_SUBDOMAIN_NAME
###
Write-Host "Getting Release for $slug_id $PCF_MASB_VERSION"
$piv_release = Get-PIVRelease -id $slug_id | where version -Match $PCF_MASB_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
$eula = Confirm-PIVEula -access_token $access_token -slugid 82 -id 290314


Write-Host "Accepting EULA for $slug_id $PCF_MASB_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$slug_id*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($slug_id)_$($PCF_MASB_VERSION)" -Force

if (($force_product_download.ispresent) -or (!(test-path "$($output_directory.FullName)/download-file.json"))) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"

    om --skip-ssl-validation `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug $slug_id `
        --product-version $PCF_MASB_VERSION `
        --stemcell-iaas azure `
        --download-stemcell `
        --output-directory  "$($output_directory.FullName)"
}

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME = $download_file.product_path
$STEMCELL_FILENAME = $download_file.stemcell_path
$STEMCELL_VERSION =  $download_file.stemcell_version


Write-Host "importing $TARGET_FILENAME into OpsManager"
# Import the tile to Ops Manager.
om --skip-ssl-validation `
    --request-timeout 3600 `
    upload-product `
    --product $TARGET_FILENAME
Write-Host "importing $STEMCELL_FILENAME into OpsManager"  
om --skip-ssl-validation `
    upload-stemcell `
    --floating=false `
    --stemcell $STEMCELL_FILENAME

$PRODUCTS = $(om --skip-ssl-validation `
        available-products `
        --format json) | ConvertFrom-Json
# next lines for compliance to bash code
$PRODUCT = $PRODUCTS| where name -Match $slug_id
$PRODUCT_NAME = $PRODUCT.name
$VERSION = $PRODUCT.version

om --skip-ssl-validation `
    deployed-products
# 2.  Stage using om cli

om --skip-ssl-validation `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION

    om --skip-ssl-validation `
    assign-stemcell `
    --product $PRODUCT_NAME `
    --stemcell $STEMCELL_VERSION

"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet
azure_subscription_id: $AZURE_SUBSCRIPTION_ID
azure_tenant_id: $AZURE_TENANT_ID
azure_client_id: $AZURE_CLIENT_ID
azure_client_secret: $AZURE_CLIENT_SECRET
azure_broker_database_server: masb$($ENV_SHORT_NAME).database.windows.net
azure_broker_database_name: masb$($ENV_SHORT_NAME)
azure_broker_database_password: $PCF_PIVNET_UAA_TOKEN
azure_broker_database_encryption_key: 12345678901234567890123456789012
" | Set-Content $HOME/masb_vars.yaml

om --skip-ssl-validation `
    configure-product `
    -c "$config_file" -l "$HOME/masb_vars.yaml"
if (!$do_not_apply.ispresent) {
    om --skip-ssl-validation `
        apply-changes `
        --product-name $PRODUCT_NAME
}

om --skip-ssl-validation `
    deployed-products 

Pop-Location 
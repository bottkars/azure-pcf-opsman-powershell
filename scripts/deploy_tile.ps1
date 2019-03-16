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
    $DIRECTOR_CONF_FILE,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('mysql',
        'rabbitmq',
        'spring',
        'redis', 
        'apm', 
        'p-dataflow',
        'p-healthwatch', 
        'masb',
        'wavefront-nozzle',
        'pivotal_single_sign-on_service',
        'p-compliance-scanner',
        'p-event-alerts',
        'minio-internal-blobstore')]
    [string]$tile,
    [Parameter(ParameterSetName = "applyme", Mandatory = $false)]
    [Parameter(ParameterSetName = "no_apply", Mandatory = $false)]
    [Parameter(ParameterSetName = "apply_all", Mandatory = $false)]
    [switch]$update_stemcells
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
if ($director_conf.release) {
    $release = $director_conf.release
}
else {
    $release = "release"
}
Write-Verbose "Release: $Release"
$PRODUCT_FILE = "$($HOME)/$($tile).json"
if (!(Test-Path $PRODUCT_FILE)) {

    $PRODUCT_FILE = "../examples/$($release)/$($tile).json"
    Write-Verbose "using $PRODUCT_FILE"
}
$tile_conf = Get-Content $PRODUCT_FILE| ConvertFrom-Json
$PCF_VERSION = $tile_conf.PCF_VERSION
$config_file = $tile_conf.CONFIG_FILE


$OM_Target = $director_conf.OM_TARGET
[switch]$force_product_download = [System.Convert]::ToBoolean($director_conf.force_product_download)
$downloaddir = $director_conf.downloaddir
Write-Verbose $downloaddir
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$smtp_address = $env_vars.SMTP_ADDRESS
$smtp_identity = $env_vars.SMTP_IDENTITY
$smtp_password = $env_vars.SMTP_PASSWORD
$smtp_from = $env_vars.SMTP_FROM
$smtp_port = $env_vars.SMTP_PORT
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$GLOBAL_RECIPIENT_EMAIL = $env_vars.PCF_NOTIFICATIONS_EMAIL
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN

switch ($tile) {
    "p-compliance-scanner" { 
        $PRODUCT_TILE = "scanner"
    }
    "p-dataflow" {
        "
        product_name: $PRODUCT_TILE
        pcf_pas_network: pcf-pas-subnet
        pcf_service_network: pcf-services-subnet
        server_admin_password: $PCF_PIVNET_UAA_TOKEN 
        " | Set-Content "$($HOME)/$($tile)_vars.yaml"
    }
    "p-healthwatch" {
        "
        product_name: $PRODUCT_TILE
        pcf_pas_network: pcf-pas-subnet
        pcf_service_network: pcf-services-subnet
        opsman_enable_url: $OM_Target
        " | Set-Content "$($HOME)/$($tile)_vars.yaml"
    }
    Default {
        $PRODUCT_TILE = $tile
        write-verbose "writing config for $($HOME)/$($tile)_vars.yaml"
        "
        product_name: $PRODUCT_TILE
        pcf_pas_network: pcf-pas-subnet
        " | Set-Content "$($HOME)/$($tile)_vars.yaml"

    }
}


Write-Host "Getting Release for $tile $PCF_VERSION"
$piv_release = Get-PIVRelease -id $tile | where-object version -Match $PCF_VERSION | Select-Object -First 1
Write-Host "Getting Release ID for $PCF_VERSION"
$piv_release_id = $piv_release | Get-PIVFileReleaseId
Write-Host "getting Access Token"
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
if (!$access_token) {
    Write-Warning "Error getting token"
    break
}
else {
    Write-Verbose $access_token
}
Write-Host "Accepting EULA for $tile $PCF_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like "*$PRODUCT_TILE*.pivotal*"
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($tile)_$($PCF_VERSION)" -Force

if (($force_product_download.ispresent) -or (!(test-path "$($output_directory.FullName)/download-file.json"))) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"

    om --skip-ssl-validation `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug $tile `
        --product-version $PCF_VERSION `
        --output-directory  "$($output_directory.FullName)"
}

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME = $download_file.product_path

Write-Host "importing $TARGET_FILENAME into OpsManager"
# Import the tile to Ops Manager.
om --skip-ssl-validation `
    --request-timeout 3600 `
    upload-product `
    --product $TARGET_FILENAME

$PRODUCTS = $(om --skip-ssl-validation `
        available-products `
        --format json) | ConvertFrom-Json
# next lines for compliance to bash code



$PRODUCT = $PRODUCTS | where-object name -Match $PRODUCT_TILE | Sort-Object -Descending -Property version | Select-Object -First 1
$PRODUCT_NAME = $PRODUCT.name
$VERSION = $PRODUCT.version
Write-Verbose "we now have $PRODUCT_NAME"
om --skip-ssl-validation `
    deployed-products
# 2.  Stage using om cli

om --skip-ssl-validation `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION

if ($update_stemcells.ispresent) {
    $command = "$PSScriptRoot/get-lateststemcells.ps1 -DIRECTOR_CONF_FILE  $DIRECTOR_CONF_FILE"
    Write-Host "no starting $command"
    Invoke-Expression -Command $Command | Tee-Object -Append -FilePath "$($HOME)/pcfdeployer/logs/get-stemcells-$(get-date -f yyyyMMddhhmmss).log"
}
om --skip-ssl-validation `
    assign-stemcell  `
    --stemcell latest `
    --product $PRODUCT_NAME

switch ($tile) {
    "p-event-alerts" {
        $email_config_file = $tile_conf.EMAIL_CONFIG_FILE
        if ($smtp_address -and $smtp_identity -and $smtp_password -and $smtp_from -and $smtp_port ) {
            om --skip-ssl-validation `
                configure-product `
                -c "$email_config_file"  -l "$HOME/$($tile)_vars.yaml"
        }
        else {
            om --skip-ssl-validation `
                configure-product `
                -c "$config_file"  -l "$HOME/$($tile)_vars.yaml"
        }
    }   
    default {
        om --skip-ssl-validation `
            configure-product `
            -c "$config_file"  -l "$HOME/$($tile)_vars.yaml"
    }
}

switch ($PsCmdlet.ParameterSetName) { 
    "apply_all" { 
        Write-Host "Applying Changes to all Products"
        om --skip-ssl-validation `
            apply-changes 
    } 
    "no_apply" { 
        Write-Host "Applying Changes to $PRODUCT_NAME skipped"
    } 
    default {
        Write-Host "Applying Changes to $PRODUCT_NAME"
        om --skip-ssl-validation `
            apply-changes `
            --skip-unchanged-products
    }
} 

om --skip-ssl-validation `
    deployed-products 

Pop-Location 
#requires -module pivposh
param(
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [switch]$DO_NOT_APPLY,
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [switch]$APPLY_ALL,    
    [Parameter(ParameterSetName = "applyme",Mandatory = $true)]
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
if ($director_conf.branch)
  {
    $branch = $director_conf.branch
  }
else {
  $branch = "2.5"
}
$PRODUCT_FILE = "$($HOME)/rabbitmq.json"
if (!(Test-Path $PRODUCT_FILE))
{$PRODUCT_FILE = "../examples/$($branch)/rabbitmq.json"}
$rabbitmq_conf = Get-Content $PRODUCT_FILE| ConvertFrom-Json
$PCF_RABBITMQ_VERSION = $rabbitmq_conf.PCF_RABBITMQ_VERSION

[switch]$force_product_download = [System.Convert]::ToBoolean($director_conf.force_product_download)
$downloaddir = $director_conf.downloaddir

$config_file = $rabbitmq_conf.CONFIG_FILE
$OM_Target = $director_conf.OM_TARGET
# setting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:Path = "$($env:Path);$HOME/OM"

$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "p-rabbitmq"

Write-Host "Getting Release for $slug_id $PCF_RABBITMQ_VERSION"
$piv_release = Get-PIVRelease -id $slug_id | Where-Object version -Match $PCF_RABBITMQ_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $PCF_RABBITMQ_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$slug_id*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($slug_id)_$($PCF_RABBITMQ_VERSION)" -Force

if (($force_product_download.ispresent) -or (!(test-path "$($output_directory.FullName)/download-file.json"))) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"

     om --env $HOME/om_$($director_conf.RG).env `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug $slug_id `
        --product-version $PCF_RABBITMQ_VERSION `
        --output-directory  "$($output_directory.FullName)"
}

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME = $download_file.product_path



Write-Host "importing $TARGET_FILENAME into OpsManager"
# Import the tile to Ops Manager.
 om --env $HOME/om_$($director_conf.RG).env `
  --request-timeout 3600 `
  upload-product `
  --product $TARGET_FILENAME

$PRODUCTS=$( om --env $HOME/om_$($director_conf.RG).env `
  available-products `
    --format json) | ConvertFrom-Json
# next lines for compliance to bash code
$PRODUCT=$PRODUCTS | where-o name -Match $slug_id | Sort-Object -Descending -Property version | Select-Object -First 1
$PRODUCT_NAME=$PRODUCT.name
$VERSION=$PRODUCT.version

 om --env $HOME/om_$($director_conf.RG).env `
  deployed-products
  # 2.  Stage using om cli

 om --env $HOME/om_$($director_conf.RG).env `
  stage-product `
  --product-name $PRODUCT_NAME `
  --product-version $VERSION

 om --env $HOME/om_$($director_conf.RG).env `
  assign-stemcell  `
  --stemcell latest `
  --product $PRODUCT_NAME

"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet `
pcf_service_network: pcf-services-subnet `
server_admin_password: $PCF_PIVNET_UAA_TOKEN 
" | Set-Content $HOME/rabbitmq_vars.yaml

 om --env $HOME/om_$($director_conf.RG).env `
  configure-product `
  -c "$config_file" -l "$HOME/rabbitmq_vars.yaml"

switch ($PsCmdlet.ParameterSetName) { 
    "apply_all" { 
        Write-Host "Applying Changes to all Products"
         om --env $HOME/om_$($director_conf.RG).env `
            apply-changes 
    } 
    "no_apply" { 
        Write-Host "Applying Changes to $PRODUCT_NAME skipped"
    } 
    default {
        Write-Host "Applying Changes to $PRODUCT_NAME and changed Products"
         om --env $HOME/om_$($director_conf.RG).env `
            apply-changes `
            --skip-unchanged-products
    }
} 

 om --env $HOME/om_$($director_conf.RG).env `
  deployed-products 

Pop-Location 
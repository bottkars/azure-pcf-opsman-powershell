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
$tile="pasw"
Write-Verbose "Release: $branch"
$PRODUCT_FILE = "$($HOME)/$($tile).json"
if (!(Test-Path $PRODUCT_FILE)) {

    $PRODUCT_FILE = "../examples/$($branch)/$($tile).json"
    Write-Verbose "using $PRODUCT_FILE"
}
$tile_conf = Get-Content $PRODUCT_FILE | ConvertFrom-Json
$PCF_VERSION = $tile_conf.PCF_VERSION
$config_file = $tile_conf.CONFIG_FILE

$OM_Target = $director_conf.OM_TARGET
[switch]$no_product_download = [System.Convert]::ToBoolean($pasw_conf.no_product_download)

# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:Path = "$($env:Path);$HOME/OM"

$PIVNET_UAA_TOKEN = $env_vars.PIVNET_UAA_TOKEN
$slug_id = "pas-windows"

$downloaddir = $director_conf.downloaddir




Write-Host "Getting Release for $slug_id $PCF_VERSION"
$piv_release = Get-PIVRelease -id $slug_id | where-object version -Match $PCF_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PIVNET_UAA_TOKEN
Write-Host "Accepting EULA for $slug_id $PCF_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$slug_id*.pivotal*
$piv_winfs_object = $piv_release_id | Where-Object aws_object_key -Like *winfs*.zip*

$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($slug_id)_$($PCF_VERSION)" -Force
$injector_directory = New-Item -ItemType Directory "$($downloaddir)/$($slug_id)_$($PCF_VERSION)_injector" -Force

 om --env $HOME/om_$($director_conf.RG).env `
    --request-timeout 7200 `
    download-product `
    --pivnet-api-token $PIVNET_UAA_TOKEN `
    --pivnet-file-glob $(Split-Path -Leaf $piv_winfs_object.aws_object_key) `
    --pivnet-product-slug $slug_id `
    --product-version $PCF_VERSION `
    --output-directory  "$($injector_directory.FullName)"


if (($force_product_download.ispresent) -or (!(test-path "$($output_directory.FullName)/download-file.json"))) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"
     om --env $HOME/om_$($director_conf.RG).env `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug $slug_id `
        --product-version $PCF_VERSION `
        --output-directory  "$($output_directory.FullName)"

}

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME = $download_file.product_path
$env:Path = "$($env:path);$($output_directory.FullName)"
Expand-Archive "$($injector_directory.FullName)/*.zip" -DestinationPath $injector_directory.FullName -Force
$winfs_injector = (Get-ChildItem $injector_directory.FullName -Filter "winfs*.exe").FullName

$output_tile = $TARGET_FILENAME -replace ".pivotal"
$output_tile = "$($output_tile)-injected.pivotal"

Start-Process $winfs_injector -Wait -ArgumentList "--input-tile $TARGET_FILENAME --output-tile $output_tile"

Write-Host "importing $TARGET_FILENAME into OpsManager"
# Import the tile to Ops Manager.
 om --env $HOME/om_$($director_conf.RG).env `
    upload-product `
    --product $TARGET_FILENAME
Pop-Location
<#
$PRODUCTS=$( om --env $HOME/om_$($director_conf.RG).env `
  available-products `
    --format json) | ConvertFrom-Json
# next lines for compliance to bash code
$VERSION= $PRODUCTS.version
$PRODUCT_NAME=$PRODUCTS.name
  # 2.  Stage using om cli

   om --env $HOME/om_$($director_conf.RG).env `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION

     om --env $HOME/om_$($director_conf.RG).env `
    assign-stemcell  `
  --stemcell latest `
    --product $PRODUCT_NAME



$PCF_KEY_PEM=get-content ./pcfdemo.local.azurestack.external.key
$PCF_KEY_PEM=$PCF_KEY_PEM  -join "\r\n"
$PCF_CERT_PEM=get-content ./pcfdemo.local.azurestack.external.crt
$PCF_CERT_PEM=$PCF_CERT_PEM  -join "\r\n"
    

"
product_name: $PRODUCT_NAME
pcf_pas_network: pcf-pas-subnet `
pcf_system_domain: sys.pcfdemo.local.azurestack.external `
pcf_apps_domain: sys.pcfdemo.local.azurestack.external `
pcf_notifications_email: email@examle.com `
pcf_cert_pem: `"$PCF_CERT_PEM`"
pcf_key_pem: `"$PCF_KEY_PEM`"
pcf_credhub_key: `"012345678901234567890`"
pcf_diego_ssh_lb: diegossh-lb
pcf_mysql_lb: mysql-lb
pcf_web_lb: pcf-lb
" | Set-Content $HOME/vars.yaml

 om --env $HOME/om_$($director_conf.RG).env `
  configure-product `
  -c $PSScriptRoot/pas.yaml -l $HOME/vars.yaml

 om --env $HOME/om_$($director_conf.RG).env `
  apply-changes
#>
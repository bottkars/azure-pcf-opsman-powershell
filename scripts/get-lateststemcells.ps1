#requires -module pivposh
param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(Mandatory = $false)]
    [switch]$apply
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$downloaddir = $director_conf.downloaddir
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN

$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN


$Releases = @()
$Releases += Get-PIVRelease -id 233 | where-object version -Match 250. | Select-Object -First 1
$Releases += Get-PIVRelease -id 233 | where-object version -Match 170. | Select-Object -First 1
$Releases += Get-PIVRelease -id 233 | where-object version -Match 97. | Select-Object -First 1
$Releases += Get-PIVRelease -id 82 | where-object version -Match 3586. | Select-Object -First 1
$Releases += Get-PIVRelease -id 82 | where-object version -Match 3541. | Select-Object -First 1
if ($apply.IsPresent)
    {
        $floating = "true"
    }
else {
    $floating = "false"
}    
foreach ($Release in $Releases) {
Write-Host  "Accepting EULA for Slug $($Release.slugid) Release $($Release.id)"
$eula =    $Release | Confirm-PIVEula -access_token $access_token
$output_directory = New-Item -ItemType Directory -Path "$downloaddir/stemcells/$($Release.version)" -Force 
$aws_object_key = ($Release | Get-PIVFileReleaseId | where-object aws_object_key -match "hyperv").aws_object_key
$stemcell_real_filename = Split-Path -Leaf $aws_object_key

Write-Host "Stemcell filename $stemcell_real_filename"
om --skip-ssl-validation `
--request-timeout 7200 `
download-product `
--pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
--pivnet-file-glob $stemcell_real_filename `
--pivnet-product-slug $Release.slugid `
--product-version $Release.version `
--output-directory $output_directory.FullName

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$STEMCELL_FILENAME = $download_file.product_path
# Copy-Item  -Path "$STEMCELL_FILENAME" -Destination "$($output_directory.FullName)/$stemcell_real_filename"
om --skip-ssl-validation `
    upload-stemcell `
    --floating=$floating `
    --stemcell $STEMCELL_FILENAME
}

#    --stemcell "$($output_directory.FullName)/$stemcell_real_filename"
if ($apply.IsPresent)
    {
    om --skip-ssl-validation `
    apply-changes `
    --skip-unchanged-products
    }

Pop-Location 
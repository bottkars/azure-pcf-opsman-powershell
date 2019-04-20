#requires -module pivposh
param(
    [Parameter(Mandatory = $false)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE="$HOME/director_pcf.json",
    [Parameter(Mandatory = $false)]
    [ValidateSet('170', '250','97','3586','3541')]
    [string[]]$Families= '170',
    [Parameter(Mandatory = $false)]
    [switch]$apply
)
Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$downloaddir = $director_conf.downloaddir
# getting the env
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:Path = "$($env:Path);$HOME/OM"
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN

$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN


$branchs = @()

foreach ($Family in $Families) 
{
    switch ($Family){
        '3586' {
                $branchs += Get-PIVRelease -id 82 | where-object version -Match 3586. | Select-Object -First 1
        }
        '3541' {
                $branchs += Get-PIVRelease -id 82 | where-object version -Match 3541. | Select-Object -First 1
        }
        default {
                $branchs += Get-PIVRelease -id 233 | where-object version -Match "$Family." | Select-Object -First 1    
            }
    }
}

if ($apply.IsPresent)
    {
        $floating = "true"
    }
else {
    $floating = "false"
}    
foreach ($branch in $branchs) {
Write-Host  "Accepting EULA for Slug $($branch.slugid) Release $($branch.id)"
$eula =    $branch | Confirm-PIVEula -access_token $access_token
$output_directory = New-Item -ItemType Directory -Path "$downloaddir/stemcells/$($branch.version)" -Force 
$aws_object_key = ($branch | Get-PIVFileReleaseId | where-object aws_object_key -match "hyperv").aws_object_key
$stemcell_real_filename = Split-Path -Leaf $aws_object_key

Write-Host "Stemcell filename $stemcell_real_filename"
 om --env $HOME/om_$($director_conf.RG).env `
--request-timeout 7200 `
download-product `
--pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
--pivnet-file-glob $stemcell_real_filename `
--pivnet-product-slug $branch.slugid `
--product-version $branch.version `
--output-directory $output_directory.FullName

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$STEMCELL_FILENAME = $download_file.product_path
# Copy-Item  -Path "$STEMCELL_FILENAME" -Destination "$($output_directory.FullName)/$stemcell_real_filename"
 om --env $HOME/om_$($director_conf.RG).env `
    upload-stemcell `
    --floating=$floating `
    --stemcell $STEMCELL_FILENAME
}

#    --stemcell "$($output_directory.FullName)/$stemcell_real_filename"
if ($apply.IsPresent)
    {
     om --env $HOME/om_$($director_conf.RG).env `
    apply-changes `
    --skip-unchanged-products
    }

Pop-Location 
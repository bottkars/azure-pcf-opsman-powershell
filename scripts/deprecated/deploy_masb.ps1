#requires -module pivposh
#requires -module NetTCPIP
#requires -module AzureRM.Sql
param(
    [Parameter(ParameterSetName = "applyme",Mandatory = $true)]
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(ParameterSetName = "no_apply", Mandatory = $true)]
    [switch]$DO_NOT_APPLY,
    [Parameter(ParameterSetName = "apply_all", Mandatory = $true)]
    [switch]$APPLY_ALL,    
    [Parameter(ParameterSetName = "applyme",Mandatory = $false)]
    [Parameter(ParameterSetName = "no_apply", Mandatory = $false)]
    [Parameter(ParameterSetName = "apply_all", Mandatory = $false)]
    [switch]$do_not_configure_azure_DB
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
$PRODUCT_FILE = "$($HOME)/masb.json"
if (!(Test-Path $PRODUCT_FILE))
{$PRODUCT_FILE = "../examples/$($branch)/masb.json"}
$masb_conf = Get-Content $PRODUCT_FILE| ConvertFrom-Json
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

$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$slug_id = "azure-service-broker"
##
$AZURE_SUBSCRIPTION_ID = $env_vars.AZURE_SUBSCRIPTION_ID
$AZURE_TENANT_ID = $env_vars.AZURE_TENANT_ID
$AZURE_CLIENT_ID = $env_vars.AZURE_CLIENT_ID
$AZURE_CLIENT_SECRET = $env_vars.AZURE_CLIENT_SECRET
$AZURE_REGION = $env_vars.AZURE_REGION
$AZURE_DATABASE_ENCRYPTION_KEY = $env_vars.AZURE_DATABASE_ENCRYPTION_KEY
$ENV_SHORT_NAME = $PCF_SUBDOMAIN_NAME
###
Write-Host "Getting Release for $slug_id $PCF_MASB_VERSION"
$piv_release = Get-PIVRelease -id $slug_id | where-object version -Match $PCF_MASB_VERSION | Select-Object -First 1
$piv_release_id = $piv_release | Get-PIVFileReleaseId
$access_token = Get-PIVaccesstoken -refresh_token $PCF_PIVNET_UAA_TOKEN
$eula = Confirm-PIVEula -access_token $access_token -slugid 82 -id 290314


Write-Host "Accepting EULA for $slug_id $PCF_MASB_VERSION"
$eula = $piv_release | Confirm-PIVEula -access_token $access_token
$piv_object = $piv_release_id | Where-Object aws_object_key -Like *$slug_id*.pivotal*
$output_directory = New-Item -ItemType Directory "$($downloaddir)/$($slug_id)_$($PCF_MASB_VERSION)" -Force

if (($force_product_download.ispresent) -or (!(test-path "$($output_directory.FullName)/download-file.json"))) {
    Write-Host "downloading $(Split-Path -Leaf $piv_object.aws_object_key) to $($output_directory.FullName)"

     om --env $HOME/om_$($RG).env `
        --request-timeout 7200 `
        download-product `
        --pivnet-api-token $PCF_PIVNET_UAA_TOKEN `
        --pivnet-file-glob $(Split-Path -Leaf $piv_object.aws_object_key) `
        --pivnet-product-slug $slug_id `
        --product-version $PCF_MASB_VERSION `
        --output-directory  "$($output_directory.FullName)"
}

$download_file = get-content "$($output_directory.FullName)/download-file.json" | ConvertFrom-Json
$TARGET_FILENAME = $download_file.product_path

Write-Host "importing $TARGET_FILENAME into OpsManager"
# Import the tile to Ops Manager.
 om --env $HOME/om_$($RG).env `
    upload-product `
    --product $TARGET_FILENAME
$PRODUCTS = $( om --env $HOME/om_$($RG).env `
        available-products `
        --format json) | ConvertFrom-Json
# next lines for compliance to bash code
$PRODUCT=$PRODUCTS | where-object name -Match $slug_id | Sort-Object -Descending -Property version | Select-Object -First 1
$PRODUCT_NAME = $PRODUCT.name
$VERSION = $PRODUCT.version

 om --env $HOME/om_$($RG).env `
    deployed-products
# 2.  Stage using om cli

 om --env $HOME/om_$($RG).env `
    stage-product `
    --product-name $PRODUCT_NAME `
    --product-version $VERSION

 om --env $HOME/om_$($RG).env `
    assign-stemcell  `
    --stemcell latest `
    --product $PRODUCT_NAME

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
azure_broker_database_encryption_key: $AZURE_DATABASE_ENCRYPTION_KEY
azure_broker_default_location: $AZURE_REGION
" | Set-Content $HOME/masb_vars.yaml
#azure_broker_database_encryption_key:  $(-join ((65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_}))

 om --env $HOME/om_$($RG).env `
    configure-product `
    -c "$config_file" -l "$HOME/masb_vars.yaml"


if (!$do_not_configure_azure_DB.ispresent)
    {
        $context = Get-AzureRmContext
        Write-Host "Now Creating Azure SQL Databas / Server for $PRODUCT_NAME"
        $Credential=New-Object -TypeName System.Management.Automation.PSCredential `
        -ArgumentList $AZURE_CLIENT_ID, ($AZURE_CLIENT_SECRET | ConvertTo-SecureString -AsPlainText -Force)
         Connect-AzureRmAccount -Credential $Credential -Tenant $AZURE_TENANT_ID -ServicePrincipal
        $resourcegroupname = "$($director_conf.RG).$($PCF_SUBDOMAIN_NAME).$($domain)"
        $startip = "0.0.0.0"
        $endip = "255.255.255.0"
        New-AzureRmResourceGroup -Name $resourcegroupname -Location $AZURE_REGION -Force
        New-AzureRmSqlServer -ResourceGroupName $resourcegroupname `
            -ServerName "masb$($ENV_SHORT_NAME)" `
            -Location $AZURE_REGION `
            -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList sqladmin, $(ConvertTo-SecureString -String $PCF_PIVNET_UAA_TOKEN -AsPlainText -Force))

        New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname `
            -ServerName "masb$($ENV_SHORT_NAME)" `
            -FirewallRuleName "All" -StartIpAddress $startip -EndIpAddress $endip
        New-AzureRmSqlServerFirewallRule -ResourceGroupName $resourcegroupname `
            -ServerName "masb$($ENV_SHORT_NAME)" `
            -FirewallRuleName "AllowedIPs" -StartIpAddress $startip -EndIpAddress $startip            

        New-AzureRmSqlDatabase  -ResourceGroupName $resourcegroupname `
            -ServerName "masb$($ENV_SHORT_NAME)" `
            -DatabaseName "masb$($ENV_SHORT_NAME)" `
            -RequestedServiceObjectiveName "Basic" 
        Get-AzureRmContext | Disconnect-AzureRmAccount  
        $context  | Set-AzureRmContext
    } 
    switch ($PsCmdlet.ParameterSetName) { 
        "apply_all" {
            Write-Host "Testing Connection to masb$($ENV_SHORT_NAME).database.windows.net" -NoNewline
            do {} until ((Test-NetConnection "masb$($ENV_SHORT_NAME).database.windows.net" -Port 1433).TcpTestSucceeded) 
            Write-Host -ForegroundColor Green "[done]" 
            Write-Host "Applying Changes to all Products"
             om --env $HOME/om_$($RG).env `
                apply-changes 
        } 
        "no_apply" {
            Write-Host "Testing Connection to masb$($ENV_SHORT_NAME).database.windows.net" -NoNewline
            do {} until ((Test-NetConnection "masb$($ENV_SHORT_NAME).database.windows.net" -Port 1433).TcpTestSucceeded) 
            Write-Host -ForegroundColor Green "[done]" 
            Write-Host "Applying Changes to $PRODUCT_NAME skipped"
        } 
        default {
            Write-Host "Testing Connection to masb$($ENV_SHORT_NAME).database.windows.net" -NoNewline
            do {} until ((Test-NetConnection "masb$($ENV_SHORT_NAME).database.windows.net" -Port 1433).TcpTestSucceeded) 
            Write-Host -ForegroundColor Green "[done]"
            Write-Host "Applying Changes to $PRODUCT_NAME"
             om --env $HOME/om_$($RG).env `
                apply-changes `
                --product-name $PRODUCT_NAME 
        }
    }        

 om --env $HOME/om_$($RG).env `
    deployed-products 

Pop-Location 
# about
param(
$OM_Target = "pcfopsmangreen.local.cloudapp.azurestack.external",
# set to true if downloading 
$domain = "local.azurestack.external",
$boshstorageaccountname ="pcfrgopsmanstorage",
$RG = "PCF_RG",
$deploymentstorageaccount = "*xtrastrgl5mtmcwe4ongg*",
$pas_cidr,
$pas_range,
$pas_gateway,
$infrastructure_range,
$infrastructure_cidr,
$infrastructure_gateway,
$services_cidr,
$services_gateway,
$services_range
)
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"

$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN
$ntp_servers_string =$env_vars.NTP_SERVERS_STRING

$env:Path = "$($env:Path);$HOME/OM"
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN

$ssh_public_key = Get-Content $HOME/opsman.pub
$ssh_private_key = Get-Content $HOME/opsman
$ssh_private_key = $ssh_private_key -join "\r\n"
$ca_cert = Get-Content $HOME/root.pem
$ca_cert = $ca_cert -join "\r\n"
$content=get-content "$PSScriptRoot/director_vars.yaml"

$content += "subscription_id: $((Get-AzureRmSubscription).SubscriptionId)"
$content += "tenant_id: $((Get-AzureRmSubscription).TenantId)"
$content += "client_id: $($env_vars.client_id)"
$content += "client_secret: $($env_vars.client_secret)"
$content += "domain: $domain"
$content += "deployments_storage_account_name: `"$deploymentstorageaccount`""
$content += "resource_group_name: $RG"
$content += "bosh_storage_account_name: $boshstorageaccountname"
$content += "ntp_servers_string: $ntp_servers_string"
$content += "ressource: $((Get-AzureRmContext).Environment.ActiveDirectoryServiceEndpointResourceId)"
$content += "ssh_public_key: `"$ssh_public_key`""
$content += "ssh_private_key: `"$ssh_private_key`""
$content += "ca_cert: `"$ca_cert`""
$content += "pas_cidr: $pas_cidr"
$content += "pas_range: $pas_range"
$content += "pas_gateway: $pas_gateway"
$content += "infrastructure_cidr: $infrastructure_cidr"
$content += "infrastructure_range: $infrastructure_range"
$content += "infrastructure_gateway: $infrastructure_gateway"
$content += "services_cidr: $services_cidr"
$content += "services_range: $services_range"
$content += "services_gateway: $services_gateway"
$content | Set-Content $HOME/director_vars.yaml


om --skip-ssl-validation `
configure-authentication `
--decryption-passphrase $PCF_PIVNET_UAA_TOKEN

om --skip-ssl-validation `
deployed-products

om --skip-ssl-validation `
 configure-director --config "$PSScriptRoot/director_conf.yaml" --vars-file "$HOME/director_vars.yaml"

om --skip-ssl-validation apply-changes

om --skip-ssl-validation `
 deployed-products

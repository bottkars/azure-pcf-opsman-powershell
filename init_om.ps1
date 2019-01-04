$env:OM_Password = "Password123!"
$env:OM_Target = "pcfopsmangreen.local.cloudapp.azurestack.external"
$env:OM_Username = "opsman"

$env:Path = "$($env:Path);$HOME/OM"
$RG="PCF_RG"


$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$PCF_PIVNET_UAA_TOKEN = $env_vars.PCF_PIVNET_UAA_TOKEN




$ssh_private_key = Get-Content $HOME/opsman
$ssh_private_key = $ssh_private_key -join "\r\n"
$ca_cert = Get-Content $HOME/root.pem
$ca_cert = $ca_cert -join "\r\n"
$content=get-content ./director_vars.yaml

$content += "subscription_id: $((Get-AzureRmSubscription).SubscriptionId)"
$content += "tenant_id: $((Get-AzureRmSubscription).TenantId)"
$content += "client_id: $($env_vars.client_id)"
$content += "client_secret: $($env_vars.client_secret)"
$content += "ressource_group: $RG"
$content += "ressource: $((Get-AzureRmContext).Environment.ActiveDirectoryServiceEndpointResourceId)"
$content += "ssh_private_key: `"$ssh_private_key`""
$content += "ca_cert: `"$ca_cert`""
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

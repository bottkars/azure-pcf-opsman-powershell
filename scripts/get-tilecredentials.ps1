$director_conf = Get-Content "$($HOME)/director.json" | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:OM_Password = $env_vars.OM_Password
$env:OM_Username = $env_vars.OM_Username
$env:OM_Target = $OM_Target
$env:Path = "$($env:Path);$HOME/OM"

$BOSH_CREDENTIALS= om --skip-ssl-validation `
    curl `
      --silent `
      --path /api/v0/deployed/director/credentials/bosh_commandline_credentials

Write-Output $BOSH_CREDENTIALS
      <#
sudo mkdir -p /var/tempest/workspaces/default
<#
sudo sh -c `
  "om `
    --skip-ssl-validation `
    --target ${PKS_OPSMAN_FQDN} `
    --username ${PKS_OPSMAN_USERNAME} `
    --password ${PIVNET_UAA_TOKEN} `
    curl `
      --silent `
      --path "/api/v0/security/root_ca_certificate" |
        jq --raw-output '.root_ca_certificate_pem' `
          > /var/tempest/workspaces/default/root_ca_certificate"

PCF_PKS_GUID=$( `
  om --skip-ssl-validation `
    curl `
      --silent `
      --path /api/v0/deployed/products | `
        jq --raw-output '.[] | select(.type=="pivotal-container-service") | .guid' `
)

PCF_PKS_UAA_MANAGEMENT_PASSWORD=$( `
  om --skip-ssl-validation `
    curl `
      --silent `
      --path /api/v0/deployed/products/${PCF_PKS_GUID}/credentials/.properties.pks_uaa_management_admin_client | `
        jq --raw-output '.credential.value.secret' `
)  
#> 
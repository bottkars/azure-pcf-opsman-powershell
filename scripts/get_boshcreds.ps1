param(
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE="$HOME/director_pcfprod.json"
)
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$OM_Target = $director_conf.OM_TARGET
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
$env:Path = "$($env:Path);$HOME/OM"


$BOSH_CREDENTIALS=om `
    --skip-ssl-validation `
    curl `
      --silent `
      --path /api/v0/deployed/director/credentials/bosh_commandline_credentials | `
        ConvertFrom-Json

$BOSH_CREDENTIALS.credential=$BOSH_CREDENTIALS.credential -replace "BOSH","`$BOSH"
$BOSH_CREDENTIALS.credential=$BOSH_CREDENTIALS.credential -replace "=","=`""
$BOSH_CREDENTIALS.credential=$BOSH_CREDENTIALS.credential -replace " ","`" "
$BOSH_CRED=$BOSH_CREDENTIALS.credential -split " "
$BOSH_CRED=$BOSH_CRED[0..3]
$BOSH_CRED | Invoke-Expression
write-output $BOSH_CRED


param(
    [Parameter(Mandatory = $true)]
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet(
        'staged',
        'available',
        'deployed')]
        $state = "available"
)

Push-Location $PSScriptRoot
$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$env:Path = "$($env:Path);$HOME/OM"
try
{$PRODUCTS=$( om --env $HOME/om_$($DIRECTOR_CONF.RG).env `
    curl --path /api/v0/$state/products 2>$null | ConvertFrom-Json)
}
catch
{
    Write-Host "There was an error"
    Pop-Location
    Break
}
Write-Output $PRODUCTS
Pop-Location
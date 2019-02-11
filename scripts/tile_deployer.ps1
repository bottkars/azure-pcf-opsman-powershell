#requires -module pivposh
#requires -module NetTCPIP
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('mysql', 'rabbitmq', 'spring', 'redis', 'apm', 'dataflow', 'healthwatch', 'masb')]
    [string[]]$tiles,
    [Parameter(Mandatory = $true)]	
    [Validatescript( {Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE,
    [Parameter(Mandatory = $false)]	
    [switch]$DO_NOT_APPLY,
    [Parameter(Mandatory = $false)]
    [switch]$do_not_configure_azure_DB
)
$ScriptDir = "$PSScriptRoot"
Push-Location $PSScriptRoot

#$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json


if ($tiles -contains 'spring') {
    $tiles = ('mysql', 'rabbitmq', 'spring') + $tiles
    $tiles = $tiles | Select-Object -Unique
    $compute_instances = 2
}
if ($tiles -contains 'dataflow') {
    $tiles = ('mysql', 'rabbitmq', 'redis', 'dataflow') + $tiles
    $tiles = $tiles | Select-Object -Unique
}
if ($tiles -contains 'masb') {
    if (!$env_vars.AZURE_CLIENT_ID `
            -or !$env_vars.AZURE_CLIENT_SECRET `
            -or !$env_vars.AZURE_REGION `
            -or !$env_vars.AZURE_SUBSCRIPTION_ID `
            -or !$env_vars.AZURE_TENANT_ID `
            -or !$env_vars.AZURE_DATABASE_ENCRYPTION_KEY  
    ) {
        Write-Host -ForegroundColor White "Microsoft Azure Service Broker needs
                AZURE_CLIENT_ID 
                AZURE_CLIENT_SECRET 
                AZURE_REGION 
                AZURE_SUBSCRIPTION_ID 
                AZURE_TENANT_ID
                AZURE_DATABASE_ENCRYPTION_KEY
to be set correctly with role `contributor`for the Service Principal at the AZURE subscription level"
        Pop-Location
        break
    }

  
} 
Write-Host -ForegroundColor White -NoNewline "Going to deploy PCF $PASTYPE with the Following Tiles: "
Write-Host -ForegroundColor Green  "$($tiles -join ",")"

$Deploy_tile_times = @() 

ForEach ($tile in $tiles) {
    $StopWatch_Tile_deploy = New-Object System.Diagnostics.Stopwatch
    $StopWatch_Tile_deploy.Start()
    if ($tile -match $tiles[-1]) {
        $command = "$ScriptDir/deploy_$($tile).ps1 -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -APPLY_ALL"
    }
    else {
        $command = "$ScriptDir/deploy_$($tile).ps1 -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -DO_NOT_APPLY"
    }
    Write-Host "Calling $command" 
    Invoke-Expression -Command $Command | Tee-Object -Append -FilePath "$($HOME)/$($tile)-$(get-date -f yyyyMMddhhmmss).log"
    $StopWatch_Tile_deploy.Stop()
    $DeployTimes += "$tile deployment took $($StopWatch_Tile_deploy.Elapsed.Hours) hours, $($StopWatch_Tile_deploy.Elapsed.Minutes) minutes and  $($StopWatch_Tile_deploy.Elapsed.Seconds) seconds"
}
Write-Host $Deploy_tile_times
Pop-Location
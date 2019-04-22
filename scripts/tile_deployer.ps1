#requires -module pivposh
#requires -module NetTCPIP
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet(
        'pivotal-mysql',
        'p-rabbitmq',
        'p-spring-cloud-services',
        'p-redis', 
        'apm', 
        'p-dataflow',
        'p-healthwatch', 
        'azure-service-broker',
        'wavefront-nozzle',
        'Pivotal_Single_Sign-On_Service',
        'p-compliance-scanner',
        'p-event-alerts',
        'minio-internal-blobstore')] 
    [string[]]$tiles,
    [Parameter(Mandatory = $false)]	
    [Validatescript( { Test-Path -Path $_ })]
    $DIRECTOR_CONF_FILE="$HOME/director_pcf.json",
    [Parameter(Mandatory = $false)]	
    [switch]$DO_NOT_APPLY,
    [Parameter(Mandatory = $false)]
    [switch]$do_not_configure_azure_DB
)
$ScriptDir = "$PSScriptRoot"
Push-Location $PSScriptRoot
New-Item -ItemType Directory -Path "$($HOME)/pcfdeployer/logs" -Force | Out-Null
#$director_conf = Get-Content $DIRECTOR_CONF_FILE | ConvertFrom-Json
$env_vars = Get-Content $HOME/env.json | ConvertFrom-Json


if ($tiles -contains 'p-spring-cloud-services') {
    $tiles = ('pivotal-mysql', 'p-rabbitmq', 'p-spring-cloud-services') + $tiles
    $tiles = $tiles | Select-Object -Unique
}
if ($tiles -contains 'dataflow') {
    $tiles = ('pivotal-mysql', 'p-rabbitmq', 'p-redis', 'dataflow') + $tiles
    $tiles = $tiles | Select-Object -Unique
}
if ($tiles -contains 'p-event-alerts') {
    $tiles = ('pivotal-mysql', 'p-event-alerts') + $tiles
    $tiles = $tiles | Select-Object -Unique
}

if ($tiles -contains 'azure-service-broker') {
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
        if ($DO_NOT_APPLY.IsPresent) {
            $command = "$ScriptDir/deploy_tile.ps1 -tile $tile -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -DO_NOT_APPLY"

        }
        else {              
            $command = "$ScriptDir/deploy_tile.ps1 -tile $tile -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE"
      
        }    
    }
    else {
        $command = "$ScriptDir/deploy_tile.ps1 -tile $tile -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -DO_NOT_APPLY"
    }
    Write-Host "Calling $command" 
    Invoke-Expression -Command $Command | Tee-Object -Append -FilePath "$($HOME)/pcfdeployer/logs/$($tile)-$(Get-Date -f yyyyMMddhhmmss).log"
    $StopWatch_Tile_deploy.Stop()
    $DeployTimes += "$tile deployment took $($StopWatch_Tile_deploy.Elapsed.Hours) hours, $($StopWatch_Tile_deploy.Elapsed.Minutes) minutes and  $($StopWatch_Tile_deploy.Elapsed.Seconds) seconds"
}
Write-Host $Deploy_tile_times
Pop-Location
param(
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet(
        ## 2.1 starts here
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.204.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.212.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.214.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.304.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.314.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.318.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.326.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.335.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.340.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.341.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.348.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.350.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.355.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.361.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.372.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.377.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.1-build.389.vhd',
        ## 2.2 starts here
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.292.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.296.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.300.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.304.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.312.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.316.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.319.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.334.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.352.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.359.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.372.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.376.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.380.vhd',        
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.382.vhd',        

        ## 2.3 starts here
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.146.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.167.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.170.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.184.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.188.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.194.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.212.vhd',        
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.224.vhd',        
        ## 2.4 starts here
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.4-build.117.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.4-build.131.vhd'
    )]
    $opsmanager_uri = 'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.224.vhd',
    # The name of the Ressource Group we want to Deploy to.
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $resourceGroup = 'PCF_RG',
    # region of the Deployment., local for ASDK
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $location = $GLOBAL:AZS_Location,
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $dnsdomain = $Global:dnsdomain,
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    $storageaccount,
    # The Containername we will host the Images for Opsmanager in
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $image_containername = 'opsman-image',
    # The SSH Key for OpsManager
    [Parameter(ParameterSetName = "1", Mandatory = $true)]$OPSMAN_SSHKEY,
    $opsManFQDNPrefix = "pcfopsman",
    $dnsZoneName = "pcfdemo.local.azurestack.external",
    [switch]$RegisterProviders,
    [switch]$OpsmanUpdate,
    [Parameter(ParameterSetName = "1", Mandatory = $false)][ValidateSet('green', 'blue')]$deploymentcolor = "green",
    [ipaddress]$subnet = "10.0.0.0",
    $downloadpath = "$($HOME)/Downloads",
    # [switch]$useManagedDisks, wait´s for new cpi...
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AzureCloud', 'AzureStack')]$Environment = "AzureStack",
    # PAS Version
    [Parameter(Mandatory = $false)][ValidateSet('2.4.0', '2.4.1', '2.3.5', '2.3.4', '2.3.3')]
    $PCF_PAS_VERSION = "2.3.5",
    # PAS Type ( srt for small runtime, cf for full pas)
    [Parameter(Mandatory = $false)][ValidateSet('srt', 'cf')]
    $PRODUCT_NAME = "cf",
    [switch]$PAS_AUOPILOT,
    [switch]$no_product_download
)


function get-runningos {
    # backward copatibility for peeps runnin powershell 5
    write-verbose "trying to get os type ... "
    if ($env:windir) {
        $OS_Version = Get-Command "$env:windir\system32\ntdll.dll"
        $OS_Version = $OS_Version.Version
        $deploy_os_type = "win_x86_64"
        $webrequestor = ".Net"
    }
    elseif ($OS = uname) {
        write-verbose "found OS $OS"
        Switch ($OS) {
            "Darwin" {
                $Global:deploy_os_type = "OSX"
                $OS_Version = (sw_vers -productVersion)
                write-verbose $OS_Version
                try {
                    $webrequestor = (get-command curl).Path
                }
                catch {
                    Write-Warning "curl not found"
                    exit
                }
            }
            'Linux' {
                $Global:deploy_os_type = "LINUX"
                $OS_Version = (uname -o)
                #$OS_Version = $OS_Version -join " "
                try {
                    $webrequestor = (get-command curl).Path
                }
                catch {
                    Write-Warning "curl not found"
                    exit
                }
            }
            default {
                write-verbose "Sorry, rome was not build in one day"
                exit
            }
            'default' {
                write-verbose "unknown linux OS"
                break
            }
        }
    }
    else {
        write-verbose "error detecting OS"
    }

    $Object = New-Object -TypeName psobject
    $Object | Add-Member -MemberType NoteProperty -Name OSVersion -Value $OS_Version
    $Object | Add-Member -MemberType NoteProperty -Name OSType -Value $deploy_os_type
    $Object | Add-Member -MemberType NoteProperty -Name Webrequestor -Value $webrequestor
    Write-Output $Object
}
if ($Environment -eq "AzureStack" -and (get-runningos).OSType -ne "win_x86_64") {
    Write-Warning "can only deploy to stack from Windows with full AzureRM modules"
    Write-Host "Current Environment: $Environment"
    Write-Host "Current OSType $((get-runningos).OSType)"
    Break
}
Push-Location
Set-Location $PSScriptRoot
if (!$location) {
    $Location = Read-Host "Please enter your Region Name [local for asdk]"
}
if (!$dnsdomain) {
    $dnsdomain = Read-Host "Please enter your DNS Domain [azurestack.external for asdk]"
}
$blobbaseuri = (Get-AzureRmContext).Environment.StorageEndpointSuffix
$BaseNetworkVersion = [version]$subnet.IPAddressToString
$mask = "$($BaseNetworkVersion.Major).$($BaseNetworkVersion.Minor)"

$infrastructure_cidr = "$mask.8.0/26"
$infrastructure_range = "$mask.8.1-$mask.8.10"
$infrastructure_gateway = "$mask.8.1"
$pas_cidr = "$Mask.0.0/22"
$pas_range = "$mask.0.1-$mask.0.10"
$pas_gateway = "$mask.0.1"
$services_cidr = "$Mask.4.0/22"
$services_range = "$mask.4.1-$mask.4.10"
$services_gateway = "$mask.4.1"

Write-Host "Using the following Network Assignments:" -ForegroundColor Magenta
Write-Host "PCF/infrastructure  : cidr $infrastructure_cidr,range $infrastructure_range,gateway $infrastructure_gateway"
Write-Host "PCF/services        : cidr $services_cidr,range $services_range,gateway $services_gateway"
Write-Host "PCF/pas             : cidr $pas_cidr,range $pas_range,gateway $pas_gateway"
Write-Host "$($opsManFQDNPrefix)green $Mask.8.4/32"
Write-Host "$($opsManFQDNPrefix)blue $Mask.8.5/32"
Write-Host
$opsManFQDNPrefix = "$opsManFQDNPrefix$deploymentcolor"
if (!$storageaccount) {
    $storageaccount = 'opsmanstorage'
    $storageaccount = ($resourceGroup + $Storageaccount) -Replace '[^a-zA-Z0-9]', ''
    $storageaccount = ($Storageaccount.subString(0, [System.Math]::Min(23, $storageaccount.Length))).tolower()
}
$OpsManBaseUri = Split-Path  $opsmanager_uri  
$OpsmanContainer = Split-Path $OpsManBaseUri
$opsManVHD = Split-Path -Leaf $opsmanager_uri
$opsmanVersion = $opsManVHD -replace ".vhd", ""
Write-host "Preparing to deploy OpsMan $opsmanVersion for $deploymentcolor deployment" -ForegroundColor $deploymentcolor
$storageType = 'Standard_LRS'

$StopWatch_prepare = New-Object System.Diagnostics.Stopwatch
$StopWatch_deploy = New-Object System.Diagnostics.Stopwatch
$StopWatch_prepare.Start()

if (!$OpsmanUpdate) {
    Write-Host "==>Creating ResourceGroup $resourceGroup" -nonewline   
    $new_rg = New-AzureRmResourceGroup -Name $resourceGroup -Location $location
    Write-Host -ForegroundColor green "[done]"
    if ((get-runningos).OSType -eq 'win_x86_64' -or $Environment -ne 'AzureStack') {
        $account_available = Get-AzureRmStorageAccountNameAvailability -Name $storageaccount 
        $account_free = $account_available.NameAvailable
    }
    else {
        Write-Warning "we have a netcore bug with azurestack and can not test stoprageaccount availabilty"
        $account_free = $true
    }
    # bug not working in netcore against azurestack, as we can not set profiles :-( 
    # waiting for new az netcore module with updated api profiles
    # new 
    if ($account_free -eq $true) {

        Write-Host "==>Creating StorageAccount $storageaccount" -nonewline
        if ((get-runningos).OSType -eq 'win_x86_64' -or $Environment -ne 'AzureStack') {
            $new_acsaccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroup `
                -Name $storageAccount -Location $location `
                -Type $storageType
        }
        else {
            New-AzureRmResourceGroupDeployment -TemplateFile ./createstorageaacount.json -ResourceGroupName $resourceGroup -storageAccountName $storageaccount
        }

        Write-Host -ForegroundColor green "[done]"
    }
    else {
        Write-Host "$storageaccount already exists, operations might fail if not owner in same location" 
    }    
   
}
$urlOfUploadedImageVhd = ('https://' + $storageaccount + '.blob.' + $blobbaseuri + '/' + $image_containername + '/' + $opsManVHD)
Write-Host "Starting upload Procedure for $opsManVHD into storageaccount $storageaccount, this may take a while"
if ($Environment -eq 'AzureStack') {
    Write-Host "==>Checking OS Transfer Type" -nonewline 
    $transfer_type = (get-runningos).Webrequestor
    Write-Host -ForegroundColor Green "[using $transfer_type for transfer]"
    $file = split-path -Leaf $opsmanager_uri
    $localPath = "$Downloadpath/$file"
    if (!(Test-Path $localPath)) {
        switch ($transfer_type) {
            ".Net" {  
                Start-BitsTransfer -Source $opsmanager_uri -Destination $localPath -DisplayName OpsManager
            }
            Default {
                curl -o $localPath $opsmanager_uri
            }
        }
    }  
    try {
        $new_arm_vhd = Add-AzureRmVhd -ResourceGroupName $resourceGroup -Destination $urlOfUploadedImageVhd `
            -LocalFilePath $localPath -ErrorAction SilentlyContinue
    }
    catch {
        Write-Warning "Image already exists for $opsManVHD, not overwriting"
    }
}
else {
    # Blob Copy routine
    $src_context = New-AzureStorageContext -StorageAccountName opsmanagerwesteurope -Anonymous
    $dst_context = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageaccount).context
    ## check for blob
    Write-Host "==>Checking blob $opsManVHD exixts in container $image_containername for Storageaccount $storageaccount" -NoNewline
    $ExistingBlob = Get-AzureStorageBlob -Context $dst_context -Blob $opsManVHD -Container $image_containername -ErrorAction SilentlyContinue
    if (!$ExistingBlob) {
        Write-Host -ForegroundColor Green "[blob needs to be uploaded]"
        # check container
        Write-Host "==>Checking container $image_containername exists for Storageaccount $storageaccount" -NoNewline
        $ContainerExists = (Get-AzureStorageContainer -Name $image_containername -Context $dst_context -ErrorAction SilentlyContinue)
        If (!$ContainerExists) {
            Write-Host -ForegroundColor Green "[creating container]"
            $container = New-AzureStorageContainer -Name $image_containername -Permission Off -Context $dst_context            
        }
        else {
            Write-Host -ForegroundColor blue "[container already exists]"
        }
        Write-Host "==>copying $opsManVHD into Storageaccount $storageaccount" -NoNewline
        $copy = Get-AzureStorageBlob -Container images -Blob $opsManVHD -Context $src_context | `
            Start-AzureStorageBlobCopy -DestContainer $image_containername -DestContext $dst_context
        $complete = $copy | Get-AzureStorageBlobCopyState -WaitForComplete
        Write-Host -ForegroundColor green "[done copying]"
       
    }
    else {
        Write-Host -ForegroundColor Blue "[blob already exixts]"
    }
}

<## next section will be templated soon
Write-Host "==>Creating Custom Image $opsmanVersion in ResourceGroup $resourceGroup" -nonewline   

$imageConfig = New-AzureRmImageConfig `
-Location $location
$imageConfig = Set-AzureRmImageOsDisk `
-Image $imageConfig `
-OsType Linux `
-OsState Generalized `
-BlobUri $urlOfUploadedImageVhd `
-DiskSizeGB 127 `
-Caching ReadWrite
$newImage = New-AzureRmImage `
-ImageName $opsmanVersion `
-ResourceGroupName $resourceGroup `
-Image $imageConfig
Write-Host -ForegroundColor green "[done]"
## end template soon #>

$StopWatch_prepare.Stop()
if ($RegisterProviders.isPresent) {
    foreach ($provider in
        ('Microsoft.Compute',
            'Microsoft.Network',
            'Microsoft.Storage')
    ) {
        Get-AzureRmResourceProvider -ProviderNamespace $provider | Register-AzureRmResourceProvider
    }
}
if ( $useManagedDisks.IsPresent) {
    $ManagedDisks = "yes"
}
else {
    $ManagedDisks = "no" 
}
$parameters = @{}
$parameters.Add("SSHKeyData", $OPSMAN_SSHKEY)
$parameters.Add("opsManFQDNPrefix", $opsManFQDNPrefix)
$parameters.Add("storageAccountName", $storageaccount)
$parameters.Add("opsManVHD", $opsManVHD)
$parameters.Add("deploymentcolor", $deploymentcolor)
$parameters.Add("mask", $mask)
$parameters.Add("location", $location)
$parameters.Add("storageEndpoint", "blob.$blobbaseuri")
$parameters.Add("useManagedDisks", $ManagedDisks)
$parameters.Add("OpsManImageURI", $urlOfUploadedImageVhd)
$parameters.Add("Environment", $Environment)

$StopWatch_deploy.Start()
Write-host "Starting $deploymentcolor Deployment of $opsManFQDNPrefix $opsmanVersion" -ForegroundColor $deploymentcolor
if (!$OpsmanUpdate) {
    $parameters.Add("dnsZoneName", $dnsZoneName) 
    New-AzureRmResourceGroupDeployment -Name $resourceGroup -ResourceGroupName $resourceGroup -Mode Incremental -TemplateFile ./azuredeploy.json -TemplateParameterObject $parameters
    $MyStorageaccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup | Where-Object StorageAccountName -match $storageaccount
    $MyStorageaccount | Set-AzureRmCurrentStorageAccount
    Write-Host "Creating Container Stemcell in $($MyStorageaccount.StorageAccountName)"
    $Container = New-AzureStorageContainer -Name stemcell -Permission Blob
    Write-Host  "Creating Container bosh in $($MyStorageaccount.StorageAccountName)"
    $Container = New-AzureStorageContainer -Name bosh
    Write-Host "Creating Table Stemcells in $($MyStorageaccount.StorageAccountName)"
    $Table = New-AzureStorageTable -Name stemcells
    if (!$useManagedDisks.IsPresent) {
        $Storageaccounts = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup | Where-Object StorageAccountName -match Xtra
        
        foreach ($Mystorageaccount in $Storageaccounts) {
            $MyStorageaccount | Set-AzureRmCurrentStorageAccount
            Write-Host "Creating Container Stemcell in $($MyStorageaccount.StorageAccountName)"
            $Container = New-AzureStorageContainer -Name stemcell -Permission Blob
            Write-Host "Creating Container bosh in $($MyStorageaccount.StorageAccountName)"
            $Container = New-AzureStorageContainer -Name bosh
        }
        $deployment_storage_account = $MyStorageaccount.StorageAccountName
        $deployment_storage_account = $deployment_storage_account -replace ".$"
        $deployment_storage_account = "*$($deployment_storage_account)*"    
    }
    write host "now we are going to try and configure OpsManager"


    $command = "$PSScriptRoot/init_om.ps1 -OM_Target '$($opsManFQDNPrefix).$($location).cloudapp.$($dnsdomain)' -domain '$($location).$($dnsdomain)' -boshstorageaccountname $storageaccount -RG $resourceGroup -deploymentstorageaccount $deployment_storage_account -pas_cidr $pas_cidr -pas_range $pas_range -pas_gateway $pas_gateway -infrastructure_range $infrastructure_range -infrastructure_cidr $infrastructure_cidr -infrastructure_gateway $infrastructure_gateway -services_cidr $services_cidr -services_gateway $services_gateway -services_range $services_range"
    Write-Host "Calling $command" 
    Invoke-Expression -Command $Command
    if ($PAS_AUOPILOT.IsPresent) {
        $command = "$PSScriptRoot/deploy_pas.ps1 -OM_Target '$($opsManFQDNPrefix).$($location).cloudapp.$($dnsdomain)' -PCF_PAS_VERSION $PCF_PAS_VERSION -PRODUCT_NAME $PRODUCT_NAME -downloaddir $downloadpath"
        if ($no_product_download.IsPresent) {
            $command = "$command -no_product_download"
        }
        Write-Host "Calling $command" 
        Invoke-Expression -Command $Command
    }
}
else {
    New-AzureRmResourceGroupDeployment -Name OpsManager `
        -ResourceGroupName $resourceGroup -Mode Incremental -TemplateFile .\azuredeploy_update.json `
        -TemplateParameterObject $parameters
 
}
$StopWatch_deploy.Stop()

Write-Host "Preparation and BLOB copy job took $($StopWatch_prepare.Elapsed.Hours) hours, $($StopWatch_prepare.Elapsed.Minutes) minutes and $($StopWatch_prepare.Elapsed.Seconds) seconds" -ForegroundColor Magenta
Write-Host "ARM Deployment took $($StopWatch_deploy.Elapsed.Hours) hours, $($StopWatch_deploy.Elapsed.Minutes) minutes and  $($StopWatch_deploy.Elapsed.Seconds) seconds" -ForegroundColor Magenta
Pop-Location
##// create storage containers

    
<#
create a key
ssh-keygen -t rsa -f opsman -C ubuntu
 ssh -i opsman ubuntu@pcf-opsman.local.cloudapp.azurestack.external



<# register provider network storage keyvault, compute "!!!!!! 

login ui



https://docs.pivotal.io/pivotalcf/2-1/customizing/ops-man-api.html
uaac target https://pcf-opsman.local.cloudapp.azurestack.external/uaa --skip-ssl-validation
uaac token owner get

$ uaac token owner get
Client ID: opsman
Client secret: [Leave Blank]
User name: OPS-MAN-USERNAME
Password: OPS-MAN-PASSWORD


token="$(uaac context | awk '/^ *access_token\: *([a-zA-Z0-9.\/+\-_]+) *$/ {print $2}' -)"
curl "https://pcf-opsman.local.cloudapp.azurestack.external/api/v0/vm_types" \
    -X GET \
    -H "Authorization: bearer $token" \
    --insecure




curl -k https://pcf-opsman.local.cloudapp.azurestack.external/api/v0/vm_types -X \
PUT -H "Authorization: bearer $token" -H \
"Content-Type: application/json" -d '{"vm_types":[
{"name":"Standard_DS1_v2","ram":3584,"cpu":1,"ephemeral_disk":51200},
{"name":"Standard_DS2_v2","ram":7168,"cpu":2,"ephemeral_disk":102400},
{"name":"Standard_DS3_v2","ram":14336,"cpu":4,"ephemeral_disk":204800},
{"name":"Standard_DS4_v2","ram":28672,"cpu":8,"ephemeral_disk":409600},
{"name":"Standard_DS5_v2","ram":57344,"cpu":8,"ephemeral_disk":819200},
{"name":"Standard_DS11_v2","ram":14336,"cpu":2,"ephemeral_disk":102400},
{"name":"Standard_DS12_v2","ram":28672,"cpu":4,"ephemeral_disk":204800},
{"name":"Standard_DS13_v2","ram":57344,"cpu":8,"ephemeral_disk":409600},
{"name":"Standard_DS14_v2","ram":114688,"cpu":16,"ephemeral_disk":819200}]}' --insecure



###

$URI = "https://vmimage.blob.local.azurestack.external/vmimage/aliases.json"

az cloud register `
  -n AzureStackUser `
  --endpoint-resource-manager "https://management.local.azurestack.external" `
  --suffix-storage-endpoint "local.azurestack.external" `
  --suffix-keyvault-dns ".vault.local.azurestack.external" `
  --endpoint-active-directory-graph-resource-id "https://graph.windows.net/" `
  --endpoint-vm-image-alias-doc $uri

  #>
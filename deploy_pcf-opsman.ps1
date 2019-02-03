param(
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet(
        <## 2.1 starts here
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
        ## 2.2 starts here ##>
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
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.386.vhd',        
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.398.vhd',        
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.2-build.406.vhd',
        ## 2.3 starts here
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.146.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.167.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.170.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.184.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.188.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.194.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.212.vhd',        
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.224.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.237.vhd',        
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.244.vhd',
        ## 2.4 starts here
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.4-build.117.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.4-build.131.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.4-build.142.vhd',
        'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.4-build.145.vhd'
        ## 2.5 start here
        )]
    $opsmanager_uri = 'https://opsmanagerwesteurope.blob.core.windows.net/images/ops-manager-2.3-build.244.vhd',
    # The name of the Ressource Group we want to Deploy to.
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $resourceGroup = 'pcf',
    # Name of the Storage Resource Group for Images
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $storage_rg = 'opsmanimage_rg',    
    # region of the Deployment., local for ASDK
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $location = $GLOBAL:AZS_Location,
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $dnsdomain = $Global:dnsdomain,
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $boshstorageaccount,
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $ImageStorageAccount = "opsmanagerimage", 
    # The Containername we will host the Images for Opsmanager in
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $image_containername = 'images',
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $opsManFQDNPrefix = "pcfopsman",
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $PCF_SUBDOMAIN_NAME = "pcfdemo",
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [switch]$RegisterProviders,
    [Parameter(ParameterSetName = "update", Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [switch]$OpsmanUpdate,
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ipaddress]$subnet = "10.0.0.0",
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    $downloadpath = "$($HOME)/Downloads",
    # [switch]$useManagedDisks, wait´s for new cpi...
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('AzureCloud', 'AzureStack')]
    $Environment = "AzureStack",
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [switch]$PAS_AUTOPILOT,
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('cf', 'srt')]
    $PASTYPE = "srt",
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('mysql', 'rabbitmq', 'spring', 'redis','apm','dataflow')]
    [string[]]$tiles,
    [Parameter(ParameterSetName = "update", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('green', 'blue')]
    $deploymentcolor = "green",
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [switch]$force_product_download,
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [switch]$TESTONLY,
    [Parameter(ParameterSetName = "install", Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [switch]
    $NO_APPLY
)

$DeployTimes = @()
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

$DIRECTOR_CONF_FILE="$HOME/director_$($resourceGroup).json"   

Push-Location
Set-Location $PSScriptRoot
if (!$location) {
    $Location = Read-Host "Please enter your Region Name [local for asdk]"
}
if (!$dnsdomain) {
    $dnsdomain = Read-Host "Please enter your DNS Domain [azurestack.external for asdk]"
}

if (!(test-path -Path "$($HOME)/opsman.pub")) {
    write-host "Required $($HOME)/opsman.pub not found. please run ssh-keygen"
    Pop-Location
    Break
}
if (!(test-path -Path "$($HOME)/root.pem")) {
    write-host "Required $($HOME)/root.pem not found.
    We need the Azurestack Root CA in pem format as root.pem. If on ASDK, please export from ESRC, otherwise see your Admin"
    Pop-Location
    Break
}

$dnsZoneName = "$PCF_SUBDOMAIN_NAME.$Location.$dnsdomain"

if (!(test-path -Path "$($HOME)/$($dnsZoneName).crt")) {
    write-host "Required$($HOME)/$($dnsZoneName).crt not found. 
    Now Generating Self Signed Certificates
    "
    $command= "$PSScriptRoot/scripts/create_certs.ps1 -PCF_SUBDOMAIN_NAME $PCF_SUBDOMAIN_NAME -PCF_DOMAIN_NAME $($location).$($dnsdomain)"
    Write-Host "Now running $command"
    Invoke-Expression -Command $command
}

if (!(test-path -Path "$($HOME)/$($dnsZoneName).key")) {
    write-host "Required$($HOME)/$($dnsZoneName).key not found. 
    Now Generating Self Signed Certificates
    "
    $command= "$PSScriptRoot/scripts/create_certs.ps1 -PCF_SUBDOMAIN_NAME $PCF_SUBDOMAIN_NAME -PCF_DOMAIN_NAME $($location).$($dnsdomain)"
    Write-Host "Now running $command"
    Invoke-Expression -Command $command
}
# The SSH Key for OpsManager
$OPSMAN_SSHKEY = Get-Content "$HOME/opsman.pub"
$dnsZoneName = "$PCF_SUBDOMAIN_NAME.$Location.$dnsdomain"
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
Write-Host "$resourceGroup-virtual-network/$resourceGroup-infrastructure-subnet  : cidr $infrastructure_cidr,range $infrastructure_range,gateway $infrastructure_gateway"
Write-Host "$resourceGroup-virtual-network/$resourceGroup-services-subnet        : cidr $services_cidr,range $services_range,gateway $services_gateway"
Write-Host "$resourceGroup-virtual-network/$resourceGroup-pas-subnet             : cidr $pas_cidr,range $pas_range,gateway $pas_gateway"
Write-Host "$($opsManFQDNPrefix)green $Mask.8.4/32"
Write-Host "$($opsManFQDNPrefix)blue $Mask.8.5/32"
Write-Host

if  ($PsCmdlet.ParameterSetName -eq "install")
    {
        if ($tiles)
            {
                [switch]$PAS_AUTOPILOT = $true
                if ($tiles -contains 'spring') {
                    $tiles = ('mysql', 'rabbitmq', 'spring') + $tiles
                    $tiles = $tiles | Select-Object -Unique
                }
                if ($tiles -contains 'dataflow') {
                    $tiles = ('mysql', 'rabbitmq','redis','dataflow') + $tiles
                    $tiles = $tiles | Select-Object -Unique
                }
                Write-Host -ForegroundColor White -NoNewline "Going to deploy PCF $PASTYPE with the Following Tiles: "
                Write-Host -ForegroundColor Green  "$($tiles -join ",")"
            }
        elseif ($PAS_AUTOPILOT.IsPresent) {
            Write-Host -ForegroundColor White "Going to deploy PCF $PASTYPE without Tiles"
        }    

    }
$opsManFQDNPrefix = "$opsManFQDNPrefix$deploymentcolor"
if (!$boshstorageaccount) {
    $boshstorageaccount = 'boshstorage'
    $boshstorageaccount = ($resourceGroup + $boshStorageaccount) -Replace '[^a-zA-Z0-9]', ''
    $boshstorageaccount = ($boshStorageaccount.subString(0, [System.Math]::Min(23, $boshstorageaccount.Length))).tolower()
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
    Write-Host "==>Creating ResourceGroups $resourceGroup and $ImageStorageAccount" -nonewline   
    $new_rg = New-AzureRmResourceGroup -Name $resourceGroup -Location $location -Force
    $new_rg = New-AzureRmResourceGroup -Name $ImageStorageAccount -Location $location -Force
    Write-Host -ForegroundColor green "[done]"
    if ((get-runningos).OSType -eq 'win_x86_64' -or $Environment -ne 'AzureStack') {
        $account_available = Get-AzureRmStorageAccountNameAvailability -Name $ImageStorageAccount 
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

        Write-Host "==>Creating StorageAccount $ImageStorageAccount"
        if ((get-runningos).OSType -eq 'win_x86_64' -or $Environment -ne 'AzureStack') {
            ## test RG
            try {
                Write-Host -ForegroundColor White -NoNewline "Checking for RG $storage_rg"
                $RG=Get-AzureRmResourceGroup -Name $storage_rg -Location local -ErrorAction Stop  
            }
            catch {
                Write-Host -ForegroundColor Red [failed]
                Write-Host -ForegroundColor White -NoNewline "Creating RG $storage_rg"        
                $RG = New-AzureRmResourceGroup -Name $storage_rg -Location $location
                Write-Host -ForegroundColor Green [Done]
            }
            


            $new_acsaccount = New-AzureRmStorageAccount -ResourceGroupName $storage_rg `
                -Name $ImageStorageAccount -Location $location `
                -Type $storageType # -ErrorAction SilentlyContinue
            if (!$new_acsaccount) {
                $new_acsaccount = Get-AzureRmStorageAccount -ResourceGroupName $storage_rg | Where-Object StorageAccountName -match $ImageStorageAccount
            }    

            $new_acsaccount | Set-AzureRmCurrentStorageAccount
            Write-Host "Creating Container $image_containername in $($new_acsaccount.StorageAccountName)"
            $Container = New-AzureStorageContainer -Name $image_containername -Permission blob

        }
        else {
            write-host "Scenario currently not supported"
            BREAK
            New-AzureRmResourceGroupDeployment -TemplateFile $PSScriptRoot/createstorageaacount.json -ResourceGroupName $resourceGroup -storageAccountName $ImageStorageAccount
        }
        Write-Host -ForegroundColor green "[done]"
    }
    else {
        Write-Host "$ImageStorageAccount already exists, operations might fail if not owner in same location" 
    }  
    
    

   
}
$urlOfUploadedImageVhd = ('https://' + $ImageStorageAccount + '.blob.' + $blobbaseuri + '/' + $image_containername + '/' + $opsManVHD)
Write-Host "Starting upload Procedure for $opsManVHD into storageaccount $ImageStorageAccount, this may take a while"
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
        $new_arm_vhd = Add-AzureRmVhd -ResourceGroupName $ImageStorageAccount -Destination $urlOfUploadedImageVhd `
            -LocalFilePath $localPath -OverWrite:$false -ErrorAction SilentlyContinue -NumberOfUploaderThreads 32
    }
    catch {
        Write-Warning "Image already exists for $opsManVHD, not overwriting"
    }
}
else {
    # Blob Copy routine
    $src_context = New-AzureStorageContext -StorageAccountName opsmanagerwesteurope -Anonymous
    $dst_context = (Get-AzureRmStorageAccount -ResourceGroupName $ImageStorageAccount -Name $ImageStorageAccount).context
    ## check for blob
    Write-Host "==>Checking blob $opsManVHD exixts in container $image_containername for Storageaccount $ImageStorageAccount" -NoNewline
    $ExistingBlob = Get-AzureStorageBlob -Context $dst_context -Blob $opsManVHD -Container $image_containername -ErrorAction SilentlyContinue
    if (!$ExistingBlob) {
        Write-Host -ForegroundColor Green "[blob needs to be uploaded]"
        # check container
        Write-Host "==>Checking container $image_containername exists for Storageaccount $ImageStorageAccount" -NoNewline
        $ContainerExists = (Get-AzureStorageContainer -Name $image_containername -Context $dst_context -ErrorAction SilentlyContinue)
        If (!$ContainerExists) {
            Write-Host -ForegroundColor Green "[creating container]"
            $container = New-AzureStorageContainer -Name $image_containername -Permission Off -Context $dst_context            
        }
        else {
            Write-Host -ForegroundColor blue "[container already exists]"
        }
        Write-Host "==>copying $opsManVHD into Storageaccount $ImageStorageAccount" -NoNewline
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
    $parameters.Add("boshStorageAccountName", $boshstorageaccount)
 
    if ($TESTONLY.IsPresent) {
        Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroup -Mode Incremental -TemplateFile $PSScriptRoot/azuredeploy.json -TemplateParameterObject $parameters
    }
    else {
        New-AzureRmResourceGroupDeployment -Name $resourceGroup -ResourceGroupName $resourceGroup -Mode Incremental -TemplateFile $PSScriptRoot/azuredeploy.json -TemplateParameterObject $parameters
        $MyStorageaccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup | Where-Object StorageAccountName -match $boshstorageaccount
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
        $MYSQLStorageaccount = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup | Where-Object StorageAccountName -match mysqlstrg
        $MYSQLStorageaccount | Set-AzureRmCurrentStorageAccount
        Write-Host "Creating Container backups in $($MYSQLStorageaccount.StorageAccountName)"
        $Container = New-AzureStorageContainer -Name backups -Permission Blob
        $MYSQL_KEY = $MYSQLStorageaccount | Get-AzureRmStorageAccountKey
        $mysql_storage_account = $MYSQLStorageaccount.StorageAccountName
        $mysql_storage_key = $MYSQL_KEY[0].Value

        Write-Host "now we are going to try and configure OpsManager"
        $StopWatch_deploy_opsman = New-Object System.Diagnostics.Stopwatch
        $StopWatch_deploy_opsman.Start()
        # will create director.json for future
        $JSon = [ordered]@{
            OM_TARGET                = "$($opsManFQDNPrefix).$($dnszonename)"
            domain                   = "$($location).$($dnsdomain)"
            PCF_SUBDOMAIN_NAME       = $PCF_SUBDOMAIN_NAME
            boshstorageaccountname   = $boshstorageaccount 
            RG                       = $resourceGroup
            mysqlstorageaccountname  = $mysql_storage_account
            mysql_storage_key        = $mysql_storage_key
            deploymentstorageaccount = $deployment_storage_account
            pas_cidr                 = $pas_cidr
            pas_range                = $pas_range
            pas_gateway              = $pas_gateway 
            infrastructure_range     = $infrastructure_range
            infrastructure_cidr      = $infrastructure_cidr 
            infrastructure_gateway   = $infrastructure_gateway
            services_cidr            = $services_cidr
            services_gateway         = $services_gateway
            services_range           = $services_range
            downloaddir              = $downloadpath
            force_product_download   = $force_product_download.IsPresent.ToString()
        } | ConvertTo-Json
        $JSon | Set-Content $DIRECTOR_CONF_FILE
        if ($NO_APPLY.IsPresent) {
            $command = "$PSScriptRoot/scripts/init_om.ps1 -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE -no_apply"
        }
        else {
            $command = "$PSScriptRoot/scripts/init_om.ps1 -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE"    
        }
        
        Write-Host "Calling $command" 
        Invoke-Expression -Command $Command
        $StopWatch_deploy_opsman.Stop()
        $DeployTimes += "opsman deployment took $($StopWatch_deploy_opsman.Elapsed.Hours) hours, $($StopWatch_deploy_opsman.Elapsed.Minutes) minutes and  $($StopWatch_deploy_opsman.Elapsed.Seconds) seconds"

        if ($PAS_AUTOPILOT.IsPresent) {
            $StopWatch_deploy_pas = New-Object System.Diagnostics.Stopwatch
            $StopWatch_deploy_pas.Start()
            $command = "$PSScriptRoot/scripts/deploy_pas.ps1 -PRODUCT_NAME $PASTYPE -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE"
            Write-Host "Calling $command" 
            Invoke-Expression -Command $Command | Tee-Object -Append -FilePath "$($HOME)/pas-$(get-date -f yyyyMMddhhmmss).log"
            $StopWatch_deploy_pas.Stop()
            $DeployTimes += "PAS deployment took $($StopWatch_deploy_pas.Elapsed.Hours) hours, $($StopWatch_deploy_pas.Elapsed.Minutes) minutes and  $($StopWatch_deploy_pas.Elapsed.Seconds) seconds"

            ForEach ($tile in $tiles) {
                $StopWatch_deploy = New-Object System.Diagnostics.Stopwatch
                $StopWatch_deploy.Start()
                $command = "$PSScriptRoot/scripts/deploy_$($tile).ps1 -DIRECTOR_CONF_FILE $DIRECTOR_CONF_FILE"
                Write-Host "Calling $command" 
                Invoke-Expression -Command $Command | Tee-Object -Append -FilePath "$($HOME)/$($tile)-$(get-date -f yyyyMMddhhmmss).log"
                $StopWatch_deploy.Stop()
                $DeployTimes += "$tile deployment took $($StopWatch_deploy.Elapsed.Hours) hours, $($StopWatch_deploy.Elapsed.Minutes) minutes and  $($StopWatch_deploy.Elapsed.Seconds) seconds"
            }
        }    
    }
}
else {
    if ($TESTONLY.IsPresent) {
        Test-AzureRmResourceGroupDeployment `
            -ResourceGroupName $resourceGroup -Mode Incremental -TemplateFile .\azuredeploy_update.json `
            -TemplateParameterObject $parameters
    }
    else {
        New-AzureRmResourceGroupDeployment -Name OpsManager `
            -ResourceGroupName $resourceGroup -Mode Incremental -TemplateFile .\azuredeploy_update.json `
            -TemplateParameterObject $parameters
    }  
 
}
$StopWatch_deploy.Stop()

Write-Host "Preparation and BLOB copy job took $($StopWatch_prepare.Elapsed.Hours) hours, $($StopWatch_prepare.Elapsed.Minutes) minutes and $($StopWatch_prepare.Elapsed.Seconds) seconds" -ForegroundColor Magenta
Write-Host "Deployment took $($StopWatch_deploy.Elapsed.Hours) hours, $($StopWatch_deploy.Elapsed.Minutes) minutes and  $($StopWatch_deploy.Elapsed.Seconds) seconds" -ForegroundColor Magenta
$DeployTimes
Pop-Location
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


$URI = "https://vmimage.blob.local.azurestack.external/vmimage/aliases.json"

az cloud register `
  -n AzureStackUser `
  --endpoint-resource-manager "https://management.local.azurestack.external" `
  --suffix-storage-endpoint "local.azurestack.external" `
  --suffix-keyvault-dns ".vault.local.azurestack.external" `
  --endpoint-active-directory-graph-resource-id "https://graph.windows.net/" `
  --endpoint-vm-image-alias-doc $uri

#>
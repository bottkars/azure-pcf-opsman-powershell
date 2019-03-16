### prepare utils

<#
.Synopsis
   Short description
.DESCRIPTION
   receives OpenSSL, se get-help rEceive-LabOpenSSL -online for details
.LINK
   https://github.com/bottkars/labtools/wiki/Receive-LABOpenSSL
.EXAMPLE
#>
#requires -version 3
function Receive-LABOpenSSL
{
[CmdletBinding(DefaultParametersetName = "1",
    SupportsShouldProcess=$true,
    ConfirmImpact="Medium")]
	[OutputType([psobject])]
param(
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    $Destination="./",
    [Parameter(ParameterSetName = "1", Mandatory = $false)]
    [ValidateSet(
	'1_0_1','1_0_2','1_1_0'
    )]
    [string]$OpenSSL_Ver="1_0_2"
)

if (Test-Path -Path "$Destination")
    {
    Write-Host -ForegroundColor Gray " ==>$Destination found"
    }
else
    {
    Write-Host -ForegroundColor Gray " ==>Creating Sourcedir for OpenSSL"
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
Write-Host -ForegroundColor Gray " ==>Checking for latest OpenSSL light"

$OpenSSL_URL = "https://slproweb.com/products/Win32OpenSSL.html"
try
	{
	$Req = Invoke-WebRequest  -UseBasicParsing -Uri $OpenSSL_URL
	}
catch 
	{
	Write-Host "Error getting OpenSSL"
	$_
	break
	}
try 
	{
	Write-Host -ForegroundColor Gray " ==>Trying to Parse OpenSSL Site $OpenSSL_URL"
	$Parse = $Req.Links | where-object {$_ -Match "Win64OpenSSL_Light-$OpenSSL_Ver"}
	#https://slproweb.com/download/Win32OpenSSL_Light-1_0_1t.exe
	} 
catch
	{
	Write-Host -ForegroundColor Yellow "Error Parsing"
	$_
	break
	}

$File = ($Parse | Select-Object -First 1).outerHTML
$link = $File.Split('"') | where-object {$_ -Match "/download"}
$URL = "https://slproweb.com" + $($link)
Write-Verbose " ==>got $URL"
    $FileName = Split-Path -Leaf -Path $Url
    if (!(test-path  "$Destination\$FileName"))
        {
        Write-Host -ForegroundColor Gray " ==>$FileName not found, trying to download $Filename"
        Start-BitsTransfer  $URL -destination "$Destination\$FileName"
        }
    else
        {
        Write-Host -ForegroundColor Gray  " ==>found $Filename in $Destination"
        }
$Version = $FileName -replace "Win64OpenSSL_Light-"
$Version = $Version -replace ".exe"
$object = New-Object psobject
$object | Add-Member -MemberType NoteProperty -Name Filename -Value $FileName
$object | Add-Member -MemberType NoteProperty -Name Version -Value $Version
Write-Output $object 
}

$global:vmxtoolkit_type="win_x86_64"
Write-Host "installing module pivposh"
Install-Module pivposh -scope CurrentUser -Force
Write-Host "installing om-cli"
Install-Script Download-Om -Force -Scope CurrentUser -MinimumVersion 1.1
$OM = Download-Om -DownloadDir "$($HOME)/om" -OmRelease 0.53.0
Write-Host "Installing cf-cli Installer"
Install-Script install-cf-cli -Scope CurrentUser
Install-cf-cli.ps1 -CLIRelease '6.43.0' -DownloadDir "$HOME\Downloads" 
Write-Host "Installing cf-uaac Installer"
Install-Script install-cf-uaac -Scope CurrentUser
Install-cf-uaac.ps1 
Write-Host "Installing OpenSSL"  
$OpenSSL=Receive-LABOpenSSL -Destination "$($HOME)/Downloads" -OpenSSL_Ver 1_1_0 
$OpenSSLArgs = '/silent'
$Setuppath = "$($HOME)/Downloads/$($OpenSSL.Filename)"
unblock-file $Setuppath
Start-Process -FilePath $Setuppath -ArgumentList $OpenSSLArgs -PassThru -Wait



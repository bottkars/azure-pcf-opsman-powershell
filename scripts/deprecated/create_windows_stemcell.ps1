Get-CimInstance Win32_OperatingSystem | Select-Object `
Caption, Version, ServicePackMajorVersion, OSArchitecture, CSName, WindowsDirectory

Install-WUUpdates $(Start-WUScan)


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$release="2019.3"
Invoke-WebRequest -Uri "https://github.com/cloudfoundry-incubator/bosh-windows-stemcell-builder/releases/download/$release/agent.zip" -OutFile ./agent.zip
Invoke-Webrequest -Uri "https://github.com/cloudfoundry-incubator/bosh-windows-stemcell-builder/releases/download/$release/bosh-psmodules.zip" -OutFile ./bosh-psmodules.zip
Unblock-File ./bosh-psmodules.zip 
Expand-Archive ./bosh-psmodules.zip "C:\Program Files\WindowsPowerShell\Modules"

Install-CFFeatures
Invoke-Webrequest -Uri "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip" -OutFile ./LGPO.zip
Expand-Archive ./LGPO.zip "C:\Windows"
## reboot


Protect-CFCell


Install-Agent -IaaS Azure -agentZipPath ./agent.zip


New-Item -ItemType Directory c:\Provision
Invoke-WebRequest -Uri  "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.7.2.0p1-Beta/OpenSSH-Win64.zip" -OutFile ./OpenSSH-Win64.zip
Unblock-File ./OpenSSH-Win64.zip

Copy-Item ./OpenSSH-Win64.zip -Destination 'C:\Provision\OpenSSH-Win64.zip'
Install-SSHD -SSHZipFile 'C:\Provision\OpenSSH-Win64.zip'

Optimize-Disk
Compress-Disk


Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"


Invoke-Sysprep -IaaS Azure -NewPassword Password123! -ProductKey redacted -EnableRDP



$OSURI="https://md-000uf5ohvrmc.blob.local.azurestack.external/54df686aa8da4de4ac07867c02a6b244/abcd.vhd?sv=2017-04-17&sr=b&si=8315e625-367e-4fda-8390-1737cbdf6306&sk=system-1&sig=cL6XiA6HQu57%2FcX50PW5EshHzGHaFZyAqNspl3gOySE%3D"
$os_type="windows"
$sku="2019"
$version="2019.3.041001"
$publisher="pivotal"
$offer="bosh-windows-server-2019"

Add-AzsPlatformimage -publisher $publisher `
-offer $offer `
-sku $sku `
-version $version `
-OSType $os_type `
-OSUri $OSURI `
-Location local


cloud_properties:
  infrastructure: azure
  os_type: windows
  image:
    offer: bosh-windows-server-2019
    publisher: pivotal
    sku: '2019'
    version: 2019.3.041001
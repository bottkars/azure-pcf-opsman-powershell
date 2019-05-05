

start-powershell

$updates=start-wuscan
Install-WUUpdates -Updates $updates

$StemcellVer="2019.3"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://github.com/cloudfoundry-incubator/bosh-windows-stemcell-builder/releases/download/$StemcellVer/bosh-psmodules.zip" -OutFile ".\bosh-psmodules.zip"

Invoke-WebRequest -Uri "https://github.com/cloudfoundry-incubator/bosh-windows-stemcell-builder/releases/download/$StemcellVer/agent.zip" -OutFile ".\agent.zip"
Invoke-WebRequest -Uri "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip" -OutFile LGPO.zip
Unblock-file bosh-psmodules.zip
Unblock-file agent.zip

Expand-Archive bosh-psmodules.zip "C:\Program Files\WindowsPowerShell\Modules"

Install-CFFeatures
#reboot
# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Protect-CFCell
 
Optimize-Disk

Compress-Disk


Expand-Archive ./LGPO.zip C:\Windows

Invoke-Sysprep -IaaS Azure




$FileLink="https://md-000uf5ohvrmc.blob.local.azurestack.external/b847ca40984d47fdadbc030fd13032f6/abcd.vhd?sv=2017-04-17&sr=b&si=e696af4b-c8f5-461b-b421-1b8981f5db74&sk=system-1&sig=dAv8vP0Ja6vsUHzq%2BJ1LxLsl1WhCZ1FpR3kQIl249A0%3D"

azstemcell -vhdfile $FileLink -version 2019.3 -os 2019  -dest d:/stemcells -temp c:/temp
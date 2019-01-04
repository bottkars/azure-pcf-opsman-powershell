### prepare utils
Install-Module pivposh -scope CurrentUser -Force
$omdir = New-Item -ItemType Directory "$HOME/om"
Invoke-WebRequest -UseBasicParsing -Uri https://github.com/pivotal-cf/om/releases/download/0.48.0/om-windows.exe -OutFile "$($omdir.fullname)/om.exe"
unblock-file "$($omdir.fullname)/om.exe"
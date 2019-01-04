### prepare utils
Install-Module pivposh -scope CurrentUser -Force
Invoke-WebRequest -UseBasicParsing -Uri https://github.com/pivotal-cf/om/releases/download/0.48.0/om-windows.exe -OutFile $HOME/om/om.exe
unblock-file $HOME/om/om.exe
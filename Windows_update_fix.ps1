Stop-Service -Name BITS
Stop-Service -Name wuauserv
Rename-Item -Path "C:\Windows\System32\GroupPolicy\Machine\Registry.pol" -NewName "regpol.bak"
Invoke-Command GPUPDATE /FORCE
Start-Service -Name BITS
Start-Service -Name wuauserv
wuauclt /resetauthorization /detectnow
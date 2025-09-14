Start-Transcript -Path "C:\Windows\Temp\Install_Logs\Patch_Remediation.log" -Force

 

 

#STOP SERVICE
Stop-Service -Name wuauserv -force -ErrorAction SilentlyContinue -Verbose
Stop-Service -Name bits -force -ErrorAction SilentlyContinue -Verbose
#Stop-Service -Name ccmexec -force -ErrorAction SilentlyContinue -Verbose 
Stop-Service -Name cryptsvc -force -ErrorAction SilentlyContinue -Verbose

 


Set-Service -Name wuauserv -StartupType Disabled -Verbose 
Set-Service -Name bits -StartupType Disabled -Verbose 
#Set-Service -Name ccmexec -StartupType Disabled -Verbose 
Set-Service -Name cryptsvc -StartupType Disabled -Verbose

 

 


#REMOVE FILES AND FOLDERS
Get-ChildItem -Path "C:\ProgramData\Application Data\Microsoft\Network\Downloader" -ErrorAction SilentlyContinue | Where-Object Name -Like "qmgr*.dat" | ForEach-Object { Remove-Item -LiteralPath $_.Target -Force } -Verbose
Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Force -Recurse -ErrorAction SilentlyContinue -Verbose
Remove-Item -Path "C:\Windows\system32\catroot2\*" -Force -Recurse -ErrorAction SilentlyContinue -Verbose
Remove-Item "C:\Windows\WindowsUpdate.log" -Recurse -ErrorAction SilentlyContinue -Verbose
Remove-Item "C:\Windows\System32\GroupPolicy\Machine\Registry.pol" -Recurse -ErrorAction SilentlyContinue -Verbose

 

#RENAME FOLDER
$Date = Get-Date -Format "MMddyyyyHHmm"

 

Rename-Item -Path "C:\Windows\SoftwareDistribution" -newName "SoftwareDistribution_$Date" -force -Verbose -ErrorAction SilentlyContinue
Rename-Item -Path "C:\Windows\system32\catroot2" -newName "catroot2_$Date" -force -Verbose -ErrorAction SilentlyContinue

 


#Set Startup Type
Set-Service -Name wuauserv -StartupType Manual  -Verbose 
Set-Service -Name bits -StartupType Automatic -Verbose 
#Set-Service -Name ccmexec -StartupType Automatic -Verbose 
Set-Service -Name cryptsvc -StartupType Automatic -Verbose

 

 

#START SERVICE
Start-Service -Name wuauserv -ErrorAction SilentlyContinue -Verbose
Start-Service -Name bits -ErrorAction SilentlyContinue -Verbose
#Start-Service -Name ccmexec -ErrorAction SilentlyContinue -Verbose
Start-Service -Name cryptsvc -ErrorAction SilentlyContinue -Verbose
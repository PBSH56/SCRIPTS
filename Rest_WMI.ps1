Start-Transcript -Path "$Env:Windir\Omya\Software\Install_Logs\ResetWMI.log"
Invoke-WmiMethod -Namespace root\CCM -Class SMS_Client -Name SetClientProvisioningMode -ArgumentList $false
Start-Process -FilePath "$Env:Windir\system32\cmd.exe" -ArgumentList "/c WMIC /Namespace:\\root\ccm path SMS_Client CALL ResetPolicy 1 /NOINTERACTIVE" -Wait -Verbose
Stop-Process -Name "CcmExec" -Force -ErrorAction SilentlyContinue -Verbose
Start-Sleep -Seconds 2
Get-Item -Path HKLM:\SOFTWARE\Microsoft\SystemCertificates\SMS\Certificates -Verbose | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Verbose
Remove-Item -Path "$Env:SystemDrive\Windows\SMSCFG.ini" -Force -Verbose -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Start-Service -Name CcmExec -Confirm:$false -Verbose
Start-Process -FilePath "$Env:Windir\CCM\CcmExec.exe" -Verbose
Stop-Transcript
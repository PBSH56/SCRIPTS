$LogFile = "C:\Windows\OMYA\Software\Install_Logs\Regsync.log"



$SCCMUpdatesStore = New-Object -ComObject Microsoft.CCM.UpdatesStore
$SCCMUpdatesStore.RefreshServerComplianceState()



function LogMessage

{



    param([string]$Message, [string]$LogFile)







    ((Get-Date).ToString() + " - " + $Message) >> $LogFile;



}



function WriteLog

{



    param([string]$Message)





    LogMessage -Message $Message -LogFile $LogFile



}



WriteLog -Message "Sync State ran successfully"



#For SCCM Output
Write-Output "Sync State ransuccessfully"
$Registrypol = (TEST-PATH C:\Windows\System32\GroupPolicy\Machine\Registry.pol)
$RegistrypolOLD = (TEST-PATH C:\Windows\System32\GroupPolicy\Machine\Registry.pol.OLD)
$commentcmtx = (TEST-PATH C:\Windows\System32\GroupPolicy\Machine\comment.cmtx)
$commentcmtxOLD = (TEST-PATH C:\Windows\System32\GroupPolicy\Machine\comment.cmtx.OLD)
$SOFTWAREDISTRIBUTIONOLD = (TEST-PATH C:\Windows\SOFTWAREDISTRIBUTION.OLD)

GET-SERVICE -NAME WUAUSERV | STOP-SERVICE

IF ($Registrypol) {
    write-host "Registrypol = true"
    IF (!($RegistrypolOLD)) {
        write-host "RegistrypolOLD = FALSE"
        Rename-item -path "C:\Windows\System32\GroupPolicy\Machine\Registry.pol" -newname "Registry.pol.OLD"
    }
}

IF ($commentcmtx) {
    write-host "commentcmtx = true"
    IF (!($commentcmtxOLD)) {
        write-host "commentcmtxOLD = FALSE"
        Rename-item -path "C:\Windows\System32\GroupPolicy\Machine\comment.cmtx" -newname "comment.cmtx.OLD"
    }
}

IF (!($SOFTWAREDISTRIBUTIONOLD)) {
    write-host "SOFTWAREDISTRIBUTIONOLD = false"
    
    
    Rename-Item -path "C:\Windows\SOFTWAREDISTRIBUTION" -newname "SOFTWAREDISTRIBUTION.OLD"
    #Remove-Item C:\Windows\SOFTWAREDISTRIBUTION -Force -Recurse
    #New-Item C:\Windows\SOFTWAREDISTRIBUTION.OLD
}


GET-SERVICE -NAME WUAUSERV | START-SERVICE

Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}" #Request Machine Assignments 
Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000022}" #Evaluate Machine Policies 
Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000113}" #Scan by Update Source
Invoke-WMIMethod -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000108}" #Software Updates Assignments Evaluation Cycle
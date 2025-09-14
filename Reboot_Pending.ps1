function Test-PendingReboot {
    $rebootPending = $false
 
    # Check CBS
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
        $rebootPending = $true
    }
 
    # Check Windows Update
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
        $rebootPending = $true
    }
 
    # Check Pending File Rename
    $renameOps = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "PendingFileRenameOperations" -ErrorAction SilentlyContinue
    if ($renameOps) {
        $rebootPending = $true
    }
 
    # Check SCCM Client SDK
    $ccmClient = Get-WmiObject -Namespace "ROOT\ccm\ClientSDK" -Class CCM_ClientUtilities -ErrorAction SilentlyContinue
    if ($ccmClient) {
        $status = $ccmClient.DetermineIfRebootPending()
        if ($status.RebootPending) {
            $rebootPending = $true
        }
    }
 
    if ($rebootPending) {
        Write-Host "Pending Reboot"
    } else {
        Write-Host "No Pending Reboot"
    }
}
 
# Execute
Test-PendingReboot
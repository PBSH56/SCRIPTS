# Script to list all applied policies and their GPO source
$ReportPath = "$env:TEMP\gpresult_policy.xml"

# Generate RSoP report in XML
gpresult /x $ReportPath /f | Out-Null

# Load XML
[xml]$Report = Get-Content $ReportPath

Write-Output "=== Computer Configuration Policies ==="
$Report.Rsop.ComputerResults.ExtensionData.Extension.Policy | ForEach-Object {
    [PSCustomObject]@{
        PolicyName = $_.Name
        Setting    = $_.State
        GPO        = $_.ParentGPO.Name
    }
}

Write-Output "`n=== User Configuration Policies ==="
$Report.Rsop.UserResults.ExtensionData.Extension.Policy | ForEach-Object {
    [PSCustomObject]@{
        PolicyName = $_.Name
        Setting    = $_.State
        GPO        = $_.ParentGPO.Name
    }
}

# Cleanup
Remove-Item $ReportPath -Force
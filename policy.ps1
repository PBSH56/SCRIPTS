<#
.SYNOPSIS
    Get all applied policies and their GPO names from Resultant Set of Policy (RSoP).

.DESCRIPTION
    This script runs gpresult in XML format, parses it, and maps each applied policy
    to the GPO that applied it (Computer + User). Handles null/empty nodes safely.
#>

$ReportPath = "$env:TEMP\gpresult_full.xml"

try {
    Write-Output "Generating gpresult XML report..."
    gpresult /x $ReportPath /f | Out-Null
    [xml]$Report = Get-Content $ReportPath

    # --- Build lookup tables of GPOs ---
    $ComputerGPOs = @{}
    if ($Report.Rsop.ComputerResults.GPO) {
        $Report.Rsop.ComputerResults.GPO | ForEach-Object {
            $ComputerGPOs[$_.ID] = $_.Name
        }
    }

    $UserGPOs = @{}
    if ($Report.Rsop.UserResults.GPO) {
        $Report.Rsop.UserResults.GPO | ForEach-Object {
            $UserGPOs[$_.ID] = $_.Name
        }
    }

    # --- List Computer Configuration Policies ---
    Write-Output "`n=== Computer Configuration Policies ==="
    if ($Report.Rsop.ComputerResults.ExtensionData.Extension.Policy) {
        $Report.Rsop.ComputerResults.ExtensionData.Extension.Policy | ForEach-Object {
            $GpoName = "Unknown GPO"

            if ($_.ParentGPO) {
                if ($_.ParentGPO.ID -and $ComputerGPOs.ContainsKey($_.ParentGPO.ID)) {
                    $GpoName = $ComputerGPOs[$_.ParentGPO.ID]
                }
                elseif ($_.ParentGPO.Name) {
                    $GpoName = $_.ParentGPO.Name
                }
            }

            [PSCustomObject]@{
                PolicyName = $_.Name
                Setting    = $_.State
                GPO        = $GpoName
            }
        }
    }
    else {
        Write-Output "No Computer Configuration policies found."
    }

    # --- List User Configuration Policies ---
    Write-Output "`n=== User Configuration Policies ==="
    if ($Report.Rsop.UserResults.ExtensionData.Extension.Policy) {
        $Report.Rsop.UserResults.ExtensionData.Extension.Policy | ForEach-Object {
            $GpoName = "Unknown GPO"

            if ($_.ParentGPO) {
                if ($_.ParentGPO.ID -and $UserGPOs.ContainsKey($_.ParentGPO.ID)) {
                    $GpoName = $UserGPOs[$_.ParentGPO.ID]
                }
                elseif ($_.ParentGPO.Name) {
                    $GpoName = $_.ParentGPO.Name
                }
            }

            [PSCustomObject]@{
                PolicyName = $_.Name
                Setting    = $_.State
                GPO        = $GpoName
            }
        }
    }
    else {
        Write-Output "No User Configuration policies found."
    }
}
catch {
    Write-Output "⚠️ Error: $($_.Exception.Message)"
}
finally {
    if (Test-Path $ReportPath) {
        Remove-Item $ReportPath -Force
    }
}

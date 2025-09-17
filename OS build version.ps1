# Retrieves OS build version and installed updates in a specific format

# Import required module
Import-Module -Name Microsoft.PowerShell.Management -ErrorAction SilentlyContinue

# Initialize output file
$outputFile = "$env:USERPROFILE\Desktop\OSBuildSummary_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$logOutput = @()

# Function to log messages
function Write-Log {
    param ($Message)
    $logOutput += $Message
    Write-Host $Message
}

# 1. Get basic OS information
$osInfo = Get-ComputerInfo
$osBuild = $osInfo.OsBuildNumber
$osUBR = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name UBR).UBR
$fullBuild = "$osBuild.$osUBR"

Write-Log "$fullBuild"
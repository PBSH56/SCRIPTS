# Define registry paths
$windowsUpdatePath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
$auPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'

# Function to get and display registry properties
function Get-RegistryProperties {
    param (
        [string]$Path
    )
    
    # Try to get registry properties, handle errors
    try {
        $properties = Get-ItemProperty -Path $Path -ErrorAction Stop
        Write-Output "`nRegistry Path: $Path"
        Write-Output ("-" * 50)
        
        # Display each property in a formatted manner
        foreach ($property in $properties.PSObject.Properties) {
            if ($property.Name -ne 'PSPath' -and $property.Name -ne 'PSParentPath' -and $property.Name -ne 'PSChildName' -and $property.Name -ne 'PSDrive' -and $property.Name -ne 'PSProvider') {
                Write-Output ("{0,-30}: {1}" -f $property.Name, $property.Value)
            }
        }
    } catch {
        Write-Output "`nError accessing registry path: $Path"
    }
}

# Get registry properties for Windows Update and AU paths
Get-RegistryProperties -Path $windowsUpdatePath
Get-RegistryProperties -Path $auPath
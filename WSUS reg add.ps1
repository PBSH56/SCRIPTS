$path1 = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'  
New-ItemProperty -Path $path1 -Name 'WUServer' -Value 'address of wsus location' -PropertyType MultiString
New-ItemProperty -Path $path1 -Name 'WUStatusServer' -Value 'address of wsus location' -PropertyType MultiString
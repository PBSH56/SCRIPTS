$OldContent = (Get-ChildItem -Path "$Env:SystemDrive\Windows\ccmcache" -dir| Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-15))}).Name
ForEach ($Folder in $OldContent)

{
Remove-Item -Path "$Env:SystemDrive\Windows\ccmcache\$Folder" -Recurse


 If(!(Test-Path "$Env:SystemDrive\Windows\ccmcache\$Folder"))
 {
 Write-Output "$Folder is removed successfully"
}


}
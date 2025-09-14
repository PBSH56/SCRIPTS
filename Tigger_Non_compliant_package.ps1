

$MissingUpdates = Get-WmiObject -Class CCM_SoftwareUpdate -Filter ComplianceState=0 -Namespace root\CCM\ClientSDK
$MissingUpdatesReformatted = @($MissingUpdates | ForEach-Object {if($.ComplianceState -eq 0){[WMI]$.__PATH}})
if ( $MissingUpdatesReformatted)
{
$InstallReturn = Invoke-WmiMethod -ComputerName $env:computername -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$MissingUpdatesReformatted) -Namespace root\ccm\clientsdk
write-host "Updates found, initiated"
}
else
{
write-host "No updates found"
}
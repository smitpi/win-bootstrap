
try {
	Import-Module PSToolKit -Force
	Show-PSToolKit -ShowMetaData | Out-String
	Install-MSUpdates
} catch {Write-Warning "Error: Message:$($Error[0])"}
try {
	Install-WindowsUpdate -getUpdatesFromMS -acceptEula -SuppressReboots
	Enable-MicrosoftUpdate
} catch {Write-Warning "Error: Message:$($Error[0])"}

New-Item -Path C:\Temp\Chocolatey\Bootstrap\win_updates.tmp -ItemType file -Force | Out-Null
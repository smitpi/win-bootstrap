
try {
	Enable-MicrosoftUpdate
	Install-WindowsUpdate -getUpdatesFromMS -acceptEula -SuppressReboots
	Install-MSUpdates
} catch {Write-Warning "Error: Message:$($Error[0])"}

New-Item -Path $env:tmp\Bootstrap\win_updates.tmp -ItemType file -Force | Out-Null
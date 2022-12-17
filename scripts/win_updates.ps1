
try {
	Enable-MicrosoftUpdate
	Install-WindowsUpdate
	Install-MSUpdates
} catch {Write-Warning "Error: Message:$($Error[0])"}

New-Item -Path C:\Temp\Chocolatey\Bootstrap\win_updates.tmp -ItemType file -Force | Out-Null
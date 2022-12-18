
Write-Host '[Checking] ' -NoNewline -ForegroundColor Yellow; Write-Host 'Pending Reboot: ' -ForegroundColor Cyan -NoNewline
if (Test-PendingReboot -ComputerName $env:COMPUTERNAME) {Invoke-Reboot}
else {Write-Host 'Not Required' -ForegroundColor Green}

try {
	Import-Module PSToolKit -Force
	#Show-PSToolKit -ShowMetaData | Out-String
	Install-MSUpdate
} catch {Write-Warning "Error: Message:$($Error[0])"}
try {
	Install-WindowsUpdate -acceptEula -SuppressReboots
	Enable-MicrosoftUpdate
} catch {Write-Warning "Error: Message:$($Error[0])"}

New-Item -Path C:\Temp\Chocolatey\Bootstrap\win_updates.tmp -ItemType file -Force | Out-Null
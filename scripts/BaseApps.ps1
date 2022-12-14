$AppsInstall = @('bandizip',
	'cascadia-code-nerd-font',
	'cascadiacodepl',
	'GoogleChrome'
	'microsoft-edge',
	'microsoft-windows-terminal',
	'pwsh'
)

Write-Host '[Checking] ' -NoNewline -ForegroundColor Yellow; Write-Host 'Pending Reboot: ' -ForegroundColor Cyan -NoNewline
if (Test-PendingReboot -ComputerName $env:COMPUTERNAME) {Invoke-Reboot}
else {Write-Host 'Not Required' -ForegroundColor Green}

foreach ($app in $AppsInstall) {
	try {
		Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "$($app)" -ForegroundColor Cyan
		$VerbosePreference = 'SilentlyContinue'
		refreshenv
		choco upgrade $app --source chocolatey --accept-license --limit-output --yes
	} catch {Write-Warning "Error installing $($app): Message:$($Error[0])"}
}
New-Item -Path C:\Temp\Chocolatey\Bootstrap\BaseApps.tmp -ItemType file -Force | Out-Null
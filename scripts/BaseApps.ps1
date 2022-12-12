$AppsInstall = @('bandizip',
	'cascadia-code-nerd-font',
	'cascadiacodepl',
	'GoogleChrome'
	#'microsoft-edge',
	#'microsoft-windows-terminal',
	#'pwsh'
)

foreach ($app in $AppsInstall) {
	try {
		Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "$($app)" -ForegroundColor Cyan
		choco upgrade $app --source chocolatey --accept-license --limit-output --yes
	} catch {Write-Warning "Error installing $($app): Message:$($Error[0])"}
}

New-Item -Path $env:tmp\Bootstrap\BaseApps.tmp -ItemType file -Force
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
		choco upgrade $app --source chocolatey --accept-license --limit-output -y | Out-Null
		#if ($LASTEXITCODE -ne 0) {Write-Host ' Failed' -ForegroundColor Red}
		#if ($LASTEXITCODE -eq 0) {Write-Host ' Completed' -ForegroundColor Green}
	} catch {Write-Warning "Error installing $($app): Message:$($Error[0])"}
}


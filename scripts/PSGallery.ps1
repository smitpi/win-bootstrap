
	#region PSRepo
	if ((Get-PSRepository -Name PSGallery).InstallationPolicy -notlike 'Trusted' ) {
		try {
			Write-Host '[Setting]: ' -NoNewline -ForegroundColor Yellow; Write-Host 'PowerShell Gallery:' -ForegroundColor Cyan -NoNewline
			$null = Install-PackageProvider Nuget -Force
			$null = Register-PSRepository -Default -ErrorAction SilentlyContinue
			$null = Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
			Write-Host ' Complete' -ForegroundColor Green
		} catch {Write-Warning "Error Setting PSRepository: Message:$($Error[0])"}
	} else {Write-Host '[Setting]: ' -NoNewline -ForegroundColor Yellow; Write-Host 'PowerShell Gallery:' -ForegroundColor Cyan -NoNewline; Write-Host ' Already Set' -ForegroundColor Red}
	#endregion

	#region PackageManager
	Start-Job -ScriptBlock {
		$PowerShellGet = Get-Module 'PowerShellGet' -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1

		if ($PowerShellGet.Version -lt [version]'2.2.5') {
			Write-Host "`t[Updating]: " -NoNewline -ForegroundColor Yellow; Write-Host 'PowerShell PackageManagement' -ForegroundColor Cyan
			$installOptions = @{
				Repository = 'PSGallery'
				Force      = $true
				Scope      = 'AllUsers'
			}							
			try {
				Install-Module -Name PackageManagement @installOptions
				Write-Host "`t[Installing]: " -NoNewline -ForegroundColor Yellow; Write-Host 'PackageManagement' -ForegroundColor Cyan -NoNewline; Write-Host ' Complete' -ForegroundColor Green
			} catch {Write-Warning "Error installing PackageManagement: Message:$($Error[0])"}
			try {
				Install-Module -Name PowerShellGet @installOptions
				Write-Host "`t[Installing]: " -NoNewline -ForegroundColor Yellow; Write-Host 'PowerShellGet' -ForegroundColor Cyan -NoNewline; Write-Host ' Complete' -ForegroundColor Green
			} catch {Write-Warning "Error installing PowerShellGet: Message:$($Error[0])"}
		} else {
			Write-Host "`t[Update]: " -NoNewline -ForegroundColor Yellow; Write-Host 'PowerShell PackageManagement' -ForegroundColor Cyan -NoNewline; Write-Host ' Not Needed' -ForegroundColor Red
		}
	} | Wait-Job | Receive-Job		
	#endregion
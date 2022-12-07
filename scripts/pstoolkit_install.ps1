	#region Needed Modules
	Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "Needed PowerShell Modules`n" -ForegroundColor Cyan
	'ImportExcel', 'PSWriteHTML', 'PSWriteColor', 'PSScriptTools', 'PoshRegistry', 'Microsoft.PowerShell.Archive', 'PWSHModule', 'PSPackageMan' | ForEach-Object {		
		$module = $_
		if (-not(Get-Module $module) -and -not(Get-Module $module -ListAvailable)) {
			try {
				Write-Host "`t[Installing]: " -NoNewline -ForegroundColor Yellow; Write-Host "$($module):" -ForegroundColor Cyan -NoNewline
				Install-Module -Name $module -Scope AllUsers -AllowClobber -ErrorAction stop
				Write-Host ' Complete' -ForegroundColor Green
			} catch {Write-Warning "Error installing module $($module): Message:$($Error[0])"}
		} else {
			Write-Host "`t[Installing]: " -NoNewline -ForegroundColor Yellow; Write-Host "$($module):" -ForegroundColor Cyan -NoNewline; Write-Host ' Already Installed' -ForegroundColor Red
		}
	}
	#endregion

	#region PStoolkit
	Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "PSToolKit Module`n" -ForegroundColor Cyan
	$web = New-Object System.Net.WebClient
	$web.DownloadFile('https://raw.githubusercontent.com/smitpi/PSToolKit/master/PSToolKit/Public/Update-MyModulesFromGitHub.ps1', "$($env:TEMP)\Update-MyModulesFromGitHub.ps1")
	$full = Get-Item "$($env:TEMP)\Update-MyModulesFromGitHub.ps1"
	Import-Module $full.FullName -Force
	Update-MyModulesFromGitHub -Modules PSToolkit -AllUsers
	Remove-Item $full.FullName
	Import-Module PSToolKit -Force
	#endregion

	Set-PSToolKitSystemSetting -RunAll
	New-PSProfile
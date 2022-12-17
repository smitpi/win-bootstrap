$ModulesList = @('ImportExcel', 
'PSWriteHTML', 
'PSWriteColor', 
'PSScriptTools', 
'PoshRegistry', 
'Microsoft.PowerShell.Archive', 
'PWSHModule', 
'PSPackageMan' , 
'Carbon', 
'Pscx' , 
'PSReleaseTools', 
'PSWindowsUpdate')

#region Needed Modules
Write-Host '-----------------------------------' -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "Needed PowerShell Modules`n" -ForegroundColor Cyan
	foreach ($module in $ModulesList) {
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

New-Item -Path C:\Temp\Chocolatey\Bootstrap\modules_install.tmp -ItemType file -Force | Out-Null
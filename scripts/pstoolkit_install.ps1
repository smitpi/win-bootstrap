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
$ModulePathCheck = 'C:\Program Files\WindowsPowerShell\Modules\PSToolKit' 		
$PSTemp = "$env:tmp\PSModules"
if (Test-Path $PSTemp) {Remove-Item $PSTemp -Force -Recurse}
if (Test-Path $ModulePathCheck) {Remove-Item $ModulePathCheck -Force -Recurse}
			
$PSDownload = New-Item $PSTemp -ItemType Directory -Force
$ModulePath = New-Item $ModulePathCheck -ItemType Directory -Force
$ModuleTMPDest = Join-Path $PSDownload.FullName -ChildPath 'PSToolKit.zip'
	
$wc = New-Object System.Net.WebClient
$wc.DownloadFile('https://github.com/smitpi/PSToolKit/archive/refs/heads/master.zip', $ModuleTMPDest)
	
Expand-Archive -Path $ModuleTMPDest -DestinationPath $PSDownload.FullName -Force
$NewModule = Get-ChildItem -Directory "$($PSDownload.FullName)\PSToolKit-master\Output"
Copy-Item -Path $NewModule.FullName -Destination $ModulePath.FullName -Recurse -Force
Remove-Item $PSDownload -Force -Recurse

Import-Module PSToolKit -Force
Show-PSToolKit -ShowMetaData
#endregion

New-PSProfile
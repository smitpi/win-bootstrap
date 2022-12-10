#region Needed Modules
Write-Host '-----------------------------------' -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "Needed PowerShell Modules`n" -ForegroundColor Cyan
'ImportExcel', 'PSWriteHTML', 'PSWriteColor', 'PSScriptTools', 'PoshRegistry', 'Microsoft.PowerShell.Archive', 'PWSHModule', 'PSPackageMan' , 'Carbon', 'Pscx' , 'PSReleaseTools', 'PSWindowsUpdate' | ForEach-Object {		
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
try {
	$ModulePathCheck = 'C:\Program Files\WindowsPowerShell\Modules\PSToolKit' 		
	if (-not(Test-Path $ModulePathCheck)) {$ModulePath = New-Item $ModulePathCheck -ItemType Directory -Force}
	else {$modulepath = Get-Item $modulepathcheck}
	$ModChild = Get-ChildItem -Directory $ModulePath.FullName -ErrorAction SilentlyContinue

	[version]$InstalledVer = ($ModChild | Sort-Object -Property Name -Descending)[0].Name
	[version]$OnlineVer = (Invoke-RestMethod 'https://raw.githubusercontent.com/smitpi/pstoolkit/master/Version.json').version
	if ($InstalledVer -ne $OnlineVer) {
		$PSTemp = "$env:tmp\PSModules"
		if (Test-Path $PSTemp) {Remove-Item $PSTemp -Force -Recurse}
		$PSDownload = New-Item $PSTemp -ItemType Directory -Force
		$ModuleTMPDest = Join-Path $PSDownload.FullName -ChildPath 'PSToolKit.zip'
	
		$wc = New-Object System.Net.WebClient
		$wc.DownloadFile('https://github.com/smitpi/PSToolKit/archive/refs/heads/master.zip', $ModuleTMPDest)
	
		Microsoft.PowerShell.Archive\Expand-Archive -Path $ModuleTMPDest -DestinationPath $PSDownload.FullName -Force
		$NewModule = Get-ChildItem -Directory "$($PSDownload.FullName)\PSToolKit-master\Output"
		Copy-Item -Path $NewModule.FullName -Destination $ModulePath.FullName -Recurse -Force
		Remove-Item $PSDownload -Force -Recurse
	} else {Write-Host 'Already installed' -ForegroundColor red}
	Import-Module PSToolKit -Force
	Show-PSToolKit -ShowMetaData | Out-String
	Start-Sleep 3
} catch {Write-Warning "Error installing PSToolKit: Message:$($Error[0])"}
#endregion

Write-Host '-----------------------------------' -ForegroundColor DarkCyan; Write-Host '[Creating]: ' -NoNewline -ForegroundColor Yellow; Write-Host "PowerShell Profile`n" -ForegroundColor Cyan
New-PSProfile

Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Setting]: ' -NoNewline -ForegroundColor Yellow; Write-Host "System Settings`n" -ForegroundColor Cyan
try {
	Set-PSToolKitSystemSetting -IntranetZone -IntranetZoneIPRange -PSTrustedHosts -SetPhotoViewer -DisableIPV6 -DisableInternetExplorerESC -DisableServerManager -EnableRDP
} catch {Write-Warning "Error PSToolKitSystemSetting: Message:$($Error[0])"}

Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "VMWare Tools`n" -ForegroundColor Cyan
Install-VMWareTool

Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "RSAT Tools`n" -ForegroundColor Cyan
Install-RSAT

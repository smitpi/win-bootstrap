
#region PStoolkit
Write-Host '-----------------------------------' -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "PSToolKit Module`n" -ForegroundColor Cyan
try {
	$ModulePathCheck = 'C:\Program Files\WindowsPowerShell\Modules\PSToolKit' 		
	if (-not(Test-Path $ModulePathCheck)) {$ModulePath = New-Item $ModulePathCheck -ItemType Directory -Force}
	else {$modulepath = Get-Item $modulepathcheck}
	$ModChild = Get-ChildItem -Directory $ModulePath.FullName -ErrorAction SilentlyContinue

	if (-not([string]::IsNullOrEmpty($ModChild))) {[version]$InstalledVer = ($ModChild | Sort-Object -Property Name -Descending)[0].Name}
	[version]$OnlineVer = (Invoke-RestMethod 'https://raw.githubusercontent.com/smitpi/pstoolkit/master/Version.json').version
	if (($InstalledVer -ne $OnlineVer) -or ([string]::IsNullOrEmpty($ModChild))) {
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
	} else {Write-Host "`t[Installing]: " -NoNewline -ForegroundColor Yellow; Write-Host 'PSToolKit:' -ForegroundColor Cyan -NoNewline; Write-Host ' Already Installed' -ForegroundColor Red}
	Import-Module PSToolKit -Force
	Show-PSToolKit -ShowMetaData | Out-String
} catch {Write-Warning "Error installing PSToolKit: Message:$($Error[0])"}
#endregion

Write-Host '-----------------------------------' -ForegroundColor DarkCyan; Write-Host '[Creating]: ' -NoNewline -ForegroundColor Yellow; Write-Host "PowerShell Profile`n" -ForegroundColor Cyan
if (Test-Path $profile) {Write-Host "`t[Creating]: " -NoNewline -ForegroundColor Yellow; Write-Host 'PowerShell Profile:' -ForegroundColor Cyan -NoNewline; Write-Host ' Already Exists' -ForegroundColor Red}
else {
	New-PSProfile
}
Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Setting]: ' -NoNewline -ForegroundColor Yellow; Write-Host "System Settings`n" -ForegroundColor Cyan
try {
	Set-PSToolKitSystemSetting -IntranetZone -IntranetZoneIPRange -PSTrustedHosts -SetPhotoViewer -DisableIPV6 -DisableInternetExplorerESC -DisableServerManager -EnableRDP
} catch {Write-Warning "Error PSToolKitSystemSetting: Message:$($Error[0])"}

Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "VMWare Tools`n" -ForegroundColor Cyan
Install-VMWareTool

Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "RSAT Tools`n" -ForegroundColor Cyan
Install-RSAT

#Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Installing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "Windows Updates`n" -ForegroundColor Cyan
#Install-MSUpdate

New-Item -Path C:\Temp\Chocolatey\Bootstrap\pstoolkit_install.tmp -ItemType file -Force | Out-Null

Write-Host '[Checking] ' -NoNewline -ForegroundColor Yellow; Write-Host "Pending Reboot: " -ForegroundColor Cyan -NoNewline
if (Test-PendingReboot -ComputerName $env:COMPUTERNAME) {Invoke-Reboot}
else {Write-Host 'Not Required' -ForegroundColor Green}
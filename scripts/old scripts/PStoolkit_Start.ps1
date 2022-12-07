
$token = Read-Host "Github Token"

$PSTemp = "$env:TEMP\PSTemp"
if (test-path $PSTemp) {Remove-Item $PSTemp -Force -Recurse}
$PSDownload = New-Item $PSTemp -ItemType Directory -Force

$web = New-Object System.Net.WebClient
$web.DownloadFile('https://bit.ly/35sEu2b', "$($PSDownload.FullName)\Start-PSToolkitSystemInitialize.ps1")
$full = Get-Item "$($PSDownload.FullName)\Start-PSToolkitSystemInitialize.ps1"
Import-Module $full.FullName -Force
Start-PSToolkitSystemInitialize -GitHubToken $token -LabSetup  -InstallMyModules
Remove-Item $full.FullName

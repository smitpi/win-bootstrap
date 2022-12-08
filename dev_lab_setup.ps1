# Description: Boxstarter Script
# Author: Pierre
# Common dev settings for desktop app development

# Boxstarter options
$Boxstarter.RebootOk = $true # Allow reboots?
$Boxstarter.NoPassword = $false # Is this a machine with no login password?
$Boxstarter.AutoLogin = $true # Save my password securely and auto-login after a reboot

#. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force


Disable-UAC
$ConfirmPreference = 'None' #ensure installing PowerShell modules don't prompt on needed dependencies

# Get the base URI path from the ScriptToCall value
$bstrappackage = '-bootstrapPackage'
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", ' ')
$helperUri = $helperUri.TrimEnd("'", ' ')
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf('/'))
$helperUri += '/scripts'
Write-Host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Executing]: ' -NoNewline -ForegroundColor Yellow; Write-Host "$($helperUri)/$($script)`n" -ForegroundColor Cyan
    Invoke-Expression ((New-Object net.webclient).DownloadString("$helperUri/$script"))
}

# Workaround Choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$chocoCachePath = "$env:TEMP"

if ([string]::IsNullOrEmpty($chocoCachePath)) {
    $chocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
}
Write-Host "`n`nUsing chocoCachePath: $chocoCachePath" -ForegroundColor Yellow

if (-not (Test-Path -LiteralPath $chocoCachePath)) {
    Write-Host "`tCreating chocoCachePath directory" -ForegroundColor Yellow
    New-Item -Path $chocoCachePath -ItemType Directory -Force
}
$VerbosePreference = 'SilentlyContinue'
Write-Host "VerbosePreference = $VerbosePreference`n`n"
Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Starting]: ' -NoNewline -ForegroundColor Yellow; Write-Host "Bootstrap Script`n" -ForegroundColor Cyan


#--- Setting up Windows ---
If (!(Get-CimInstance -Class Win32_ComputerSystem).PartOfDomain) {
    #$cred = Get-Credential -UserName lab\ps -Message 'To Autologon'
    #Install-BoxstarterPackage -Package "$($helperUri)/Add_To_Domain.ps1" -Credential $cred
    executeScript 'Add_To_Domain.ps1'
} else {
    Write-Host 'Already part of a domain.' -ForegroundColor Green
}


#executeScript 'PStoolkit_Start.ps1'
executeScript 'Execution_Policy.ps1';
executeScript 'PSGallery.ps1';
executeScript 'pstoolkit_install.ps1';
executeScript 'RemoveDefaultApps.ps1';
executeScript 'FileExplorerSettings.ps1';

#--- reenabling critical items ---
RefreshEnv
if (Test-PendingReboot) {
    Invoke-Reboot
}
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula -getUpdatesFromMS
Enable-UAC

if (Test-PendingReboot) {
    Invoke-Reboot
}
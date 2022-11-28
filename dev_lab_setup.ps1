# Description: Boxstarter Script
# Author: Pierre
# Common dev settings for desktop app development

# Boxstarter options
$Boxstarter.RebootOk = $true # Allow reboots?
$Boxstarter.NoPassword = $false # Is this a machine with no login password?
$Boxstarter.AutoLogin = $true # Save my password securely and auto-login after a reboot

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
    Write-Host "executing $helperUri/$script ..."
    Invoke-Expression ((New-Object net.webclient).DownloadString("$helperUri/$script"))
}

# Workaround Choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$chocoCachePath = "$env:TEMP"

if ([string]::IsNullOrEmpty($chocoCachePath)) {
    $chocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
}
Write-Host "Using chocoCachePath: $chocoCachePath"

if (-not (Test-Path -LiteralPath $chocoCachePath)) {
    Write-Host 'Creating chocoCachePath dir.'
    New-Item -Path $chocoCachePath -ItemType Directory -Force
}

#--- Setting up Windows ---
If (!(Get-CimInstance -Class Win32_ComputerSystem).PartOfDomain) {
    $cred = Get-Credential DomainCreds
    Install-BoxstarterPackage -Package "$($helperUri)/Add_To_Domain.ps1" -Credential $cred
} else {
    Write-Host 'Already part of a domain.' -ForegroundColor Green
}


executeScript 'PStoolkit_Start.ps1'

#--- reenabling critical items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

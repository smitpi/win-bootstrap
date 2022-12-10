# Description: Boxstarter Script
# Author: Pierre
# Common dev settings for desktop app development

# Boxstarter options
$Boxstarter.RebootOk = $true # Allow reboots?
$Boxstarter.NoPassword = $false # Is this a machine with no login password?
$Boxstarter.AutoLogin = $true # Save my password securely and auto-login after a reboot

#. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force

try {
    Disable-UAC
    $ConfirmPreference = 'None' #ensure installing PowerShell modules don't prompt on needed dependencies
} catch {Write-Warning "Error: Message:$($Error[0])"}

# Get the base URI path from the ScriptToCall value
try {
    $bstrappackage = '-bootstrapPackage'
    $helperUri = $Boxstarter['ScriptToCall']
    if ($helperUri -like 'http*') {
        $IsWeb = $true
        $strpos = $helperUri.IndexOf($bstrappackage)
        $helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
        $helperUri = $helperUri.TrimStart("'", ' ')
        $helperUri = $helperUri.TrimEnd("'", ' ')
        $helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf('/'))
        $helperUri += '/scripts'
    } else {
        $IsWeb = $false
        $strpos = $helperUri.IndexOf($bstrappackage)
        $helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
        $helperUri = $helperUri.TrimStart("'", ' ')
        $helperUri = $helperUri.TrimEnd("'", ' ')
        $helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf('\'))
        $helperUri += '\scripts'
    }
    Write-Host "helper script base URI is $helperUri"
} catch {Write-Warning "Error: Message:$($Error[0])"}
function executeScript {
    Param ([string]$script)
    try {
        if ($IsWeb) {
            $VerbosePreference = 'SilentlyContinue'
            Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host "`t`t[Executing Script]: " -NoNewline -ForegroundColor Yellow; Write-Host "$($helperUri)/$($script)`n" -ForegroundColor Cyan
            Import-Module ((New-Object net.webclient).DownloadString("$helperUri/$script")) -Force
        } else {
            $VerbosePreference = 'SilentlyContinue'
            Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host "`t`t[Executing Script]: " -NoNewline -ForegroundColor Yellow; Write-Host "$($helperUri)/$($script)`n" -ForegroundColor Cyan
            Import-Module (Join-Path -Path $helperUri -ChildPath $script) -Force
        }
    } catch {Write-Warning "Error in $($script): Message:$($Error[0])"}
}

#region choco cache path
try {
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
} catch {Write-Warning "Error chocoCachePath: Message:$($Error[0])"}
#endregion choco cache path

#--- Setting up Windows ---
#region Windows Domain
If (!(Get-CimInstance -Class Win32_ComputerSystem).PartOfDomain) {
    #$cred = Get-Credential -UserName lab\ps -Message 'To Autologon'
    #Install-BoxstarterPackage -Package "$($helperUri)/Add_To_Domain.ps1" -Credential $cred
    executeScript 'Add_To_Domain.ps1'
} else {
    Write-Host 'Already part of a domain.' -ForegroundColor Green
}
#endregion Windows Domain


executeScript 'Execution_Policy.ps1';
executeScript 'PSGallery.ps1';
executeScript 'pstoolkit_install.ps1';
executeScript 'RemoveDefaultApps.ps1';
executeScript 'FileExplorerSettings.ps1';

#region choco install

# $VerbosePreference = 'SilentlyContinue'
# $common = "--cache-location=$($chocoCachePath) --yes --limit-output --no-progress --source=chocolatey"

# choco upgrade bandizip $common
# choco upgrade cascadia-code-nerd-font $common
# choco upgrade cascadiacodepl $common
# choco upgrade GoogleChrome $common
# choco upgrade microsoft-edge $common
# choco upgrade microsoft-windows-terminal $common
# choco upgrade pwsh $common
#endregion choco install

#--- reenabling critical items ---
# try {
#     Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Reenabling]: ' -NoNewline -ForegroundColor Yellow; Write-Host "Bootstrap Critical Items`n" -ForegroundColor Cyan
#     Enable-MicrosoftUpdate
#     Install-WindowsUpdate -acceptEula -getUpdatesFromMS
#     Enable-UAC

#     if (Boxstarter.Bootstrapper\Test-PendingReboot -ComputerName localhost) { Invoke-Reboot }

#     $Boxstarter.RebootOk = $false # Allow reboots?
#     $Boxstarter.NoPassword = $false # Is this a machine with no login password?
#     $Boxstarter.AutoLogin = $false # Save my password securely and auto-login after a reboot

# } catch {Write-Warning "Error: Message:$($Error[0])"}
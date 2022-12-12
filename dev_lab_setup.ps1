# Description: Boxstarter Script
# Author: Pierre
# Common dev settings for desktop app development

# Boxstarter options
$Boxstarter.RebootOk = $true # Allow reboots?
$Boxstarter.NoPassword = $false # Is this a machine with no login password?
$Boxstarter.AutoLogin = $true # Save my password securely and auto-login after a reboot

#. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force

try {
    $message = @"
  _    _ _______ _____   _____ ______           ____              _       _                   
 | |  | |__   __|  __ \ / ____|___  /   /\     |  _ \            | |     | |                  
 | |__| |  | |  | |__) | |       / /   /  \    | |_) | ___   ___ | |_ ___| |_ _ __ __ _ _ __  
 |  __  |  | |  |  ___/| |      / /   / /\ \   |  _ < / _ \ / _ \| __/ __| __| '__/ _` | '_ \ 
 | |  | |  | |  | |    | |____ / /__ / ____ \  | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) |
 |_|  |_|  |_|  |_|     \_____/_____/_/    \_\ |____/ \___/ \___/ \__|___/\__|_|  \__,_| .__/ 
                                                                                       | |    
                                                                                       |_|    
"@
    Write-Host $message -ForegroundColor Yellow
    Disable-UAC
} catch {Write-Warning "Error: Message:$($Error[0])"}

# Get the base URI path from the ScriptToCall value
try {
    $bstrappackage = '-bootstrapPackage'
    $helperUri = $Boxstarter['ScriptToCall']
    $strpos = $helperUri.IndexOf($bstrappackage)
    Write-Host "Script to call: $($helperUri.Substring($strpos + $bstrappackage.Length))" -ForegroundColor Cyan
    if ($helperUri.Substring($strpos + $bstrappackage.Length) -like '*http*') {
        Write-Host "`n`t`tURI is from the web" -ForegroundColor Yellow
        $IsWeb = $true
        $helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
        $helperUri = $helperUri.TrimStart("'", ' ')
        $helperUri = $helperUri.TrimEnd("'", ' ')
        $helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf('/'))
        $helperUri += '/scripts'
    } else {
        Write-Host "`n`t`tURI is from the local disk" -ForegroundColor Yellow
        $IsWeb = $false
        $helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
        $helperUri = $helperUri.TrimStart("'", ' ')
        $helperUri = $helperUri.TrimEnd("'", ' ')
        $helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf('\'))
        $helperUri += '\scripts'
    }
    Write-Host "Helper script base URI is $helperUri" -ForegroundColor Yellow
} catch {Write-Warning "Error: Message:$($Error[0])"}
function executeScript {
    Param ([string]$script)
    try {
        if ($IsWeb) {
            $VerbosePreference = 'SilentlyContinue'
            Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host "`t`t[Executing Script]: " -NoNewline -ForegroundColor Yellow; Write-Host "$($helperUri)/$($script)`n" -ForegroundColor Cyan
            $wc = New-Object System.Net.WebClient
            $wc.DownloadFile("$helperUri/$script", "$env:temp\$script")
            Import-Module "$env:temp\$script" -Force
        } else {
            $VerbosePreference = 'SilentlyContinue'
            Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host "`t`t[Executing Script]: " -NoNewline -ForegroundColor Yellow; Write-Host "$($helperUri)/$($script)`n" -ForegroundColor Cyan
            Import-Module (Join-Path -Path $helperUri -ChildPath $script) -Force
        }
    } catch {Write-Warning "Error in $($script): Message:$($Error[0])"}
}

#region choco cache path
try {
    $ChocoTemp = 'c:\temp\chocolatey'
    if (-not(Test-Path $ChocoTemp)) {$chocoCachePath = New-Item -ItemType Directory -Path $ChocoTemp -Force}
    else {$chocoCachePath = Get-Item $ChocoTemp}

    Write-Host "`n`nUsing chocoCachePath: $($chocoCachePath.FullName)" -ForegroundColor Yellow

    $VerbosePreference = 'SilentlyContinue'
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

if (-not(Test-Path $env:tmp\Bootstrap\BaseApps.tmp)) {
    if (Boxstarter.Bootstrapper\Test-PendingReboot) { Invoke-Reboot }
    executeScript 'BaseApps.ps1'
}

if (-not(Test-Path $env:tmp\Bootstrap)) {New-Item $env:tmp\Bootstrap -ItemType directory -Force}
if (-not(Test-Path $env:tmp\Bootstrap\Executing_policy.tmp)) {executeScript 'Execution_Policy.ps1'}
if (-not(Test-Path $env:tmp\Bootstrap\PSGallery.tmp)) {executeScript 'PSGallery.ps1'}
if (-not(Test-Path $env:tmp\Bootstrap\pstoolkit_install.tmp)) {executeScript 'pstoolkit_install.ps1'}
if (-not(Test-Path $env:tmp\Bootstrap\RemoveDefaultApps.tmp)) {executeScript 'RemoveDefaultApps.ps1'}
if (-not(Test-Path $env:tmp\Bootstrap\FileExplorerSettings.tmp)) {executeScript 'FileExplorerSettings.ps1'}

#--- reenabling critical items ---
try {
    Write-Host "`n`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Reenabling]: ' -NoNewline -ForegroundColor Yellow; Write-Host "Bootstrap Critical Items`n" -ForegroundColor Cyan
    if (Boxstarter.Bootstrapper\Test-PendingReboot) { Invoke-Reboot }
    Enable-UAC
    Enable-MicrosoftUpdate
    Install-WindowsUpdate -acceptEula -getUpdatesFromMS

    #     if (Boxstarter.Bootstrapper\Test-PendingReboot -ComputerName localhost) { Invoke-Reboot }

    #     $Boxstarter.RebootOk = $false # Allow reboots?
    #     $Boxstarter.NoPassword = $false # Is this a machine with no login password?
    #     $Boxstarter.AutoLogin = $false # Save my password securely and auto-login after a reboot

} catch {Write-Warning "Error: Message:$($Error[0])"}
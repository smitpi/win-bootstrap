# Description: Boxstarter Script
# Author: Pierre
# Common dev settings for desktop app development


$VerbosePreference = 'SilentlyContinue'
$Boxstarter.SuppressLogging = $True
$cred = Get-Credential -UserName lab\ps -Message 'To Autologon'
Install-BoxstarterPackage -Package 'https://raw.githubusercontent.com/smitpi/win-bootstrap/master/dev_lab_setup.ps1' -Credential $cred -DisableReboots -Force
Read-Host
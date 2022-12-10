# Description: Boxstarter Script
# Author: Pierre
# Common dev settings for desktop app development

#. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; Get-Boxstarter -Force
Clear-Host
Write-Host "$($Boxstarter['ScriptToCall'] | Out-String)"
$cred = Get-Credential -UserName lab\ps -Message 'To Autologon'

if (Get-Item $Boxstarter['ScriptToCall']) { Install-BoxstarterPackage -Package "$PSScriptRoot\dev_lab_setup.ps1" -Credential $cred}
else {Install-BoxstarterPackage -Package 'https://raw.githubusercontent.com/smitpi/win-bootstrap/master/dev_lab_setup.ps1' -Credential $cred}
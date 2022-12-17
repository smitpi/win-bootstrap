#Enable-MicrosoftUpdate
#Install-WindowsUpdate -getUpdatesFromMS -acceptEula -SuppressReboots
Install-MSUpdates

New-Item -Path $env:tmp\Bootstrap\win_updates.tmp -ItemType file -Force | Out-Null
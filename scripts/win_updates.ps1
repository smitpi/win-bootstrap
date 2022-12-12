Enable-MicrosoftUpdate
Install-WindowsUpdate -getUpdatesFromMS -acceptEula -SuppressReboots
New-Item -Path $env:tmp\Bootstrap\win_updates.tmp -ItemType file -Force | Out-Null
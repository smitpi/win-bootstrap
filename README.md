# win-bootstrap

Boxstarter scripts to setup a new windows machine.

```powershell

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 
iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'))
Get-Boxstarter -Force

```

|Click link to run  |Description  |
|---------|---------|
|<a href='http://boxstarter.org/package/url?https://raw.githubusercontent.com/smitpi/PSToolKit/master/PSToolKit/Control_Scripts/Initial-Setup.ps1'> System Setup</a>     | Use [PSToolKit](https://github.com/smitpi/PSToolKit) to Install a new System.|

> **Warning**
> You will need a valid **github userid** and **token** to continue

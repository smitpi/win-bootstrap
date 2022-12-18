# win-bootstrap

Boxstarter scripts to setup a new windows machine.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072 
iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'))
Get-Boxstarter -Force`
```

|Click link to run  |Description  |
|---------|---------|
|<a href='http://boxstarter.org/package/url?https://raw.githubusercontent.com/smitpi/win-bootstrap/master/dev_lab_setup.ps1'>Full Desktop App</a>     | Windows Desktop App Development |
|<a href='http://boxstarter.org/package/url?https://raw.githubusercontent.com/smitpi/PSToolKit/master/PSToolKit/Control_Scripts/Initial-Setup.ps1'> PSToolkit Setup</a>     | Use the PSToolKit Setup |

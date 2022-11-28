
try {
    Write-Host -ForegroundColor Red 'This machine is not part of a domain. Adding now.'
    # $user = Read-Host 'Userid'
    # $pass = Read-Host 'Password' -AsSecureString
    # $labcred = New-Object System.Management.Automation.PSCredential ($user, $pass)
    $labcred = Get-Credential lab\ps
    Rename-Computer -ComputerName $env:COMPUTERNAME -NewName "Dev-$(Get-Random -Maximum 5000)"
    Start-Sleep 5
    Add-Computer -DomainName 'internal.lab' -Credential $labcred -Options JoinWithNewName, AccountCreate -Force -ErrorAction Stop
    if (Test-PendingReboot) {
        Invoke-Reboot
    }
} catch {Write-Warning 'unable to add to the domain.'}

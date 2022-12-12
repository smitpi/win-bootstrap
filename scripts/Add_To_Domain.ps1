
try {

    $labcred = Get-Credential -Message 'To Add device to the domain'
    Rename-Computer -ComputerName $env:COMPUTERNAME -NewName "Dev-$(Get-Random -Maximum 5000)"
    Start-Sleep 5
    Add-Computer -DomainName 'internal.lab' -Credential $labcred -Options JoinWithNewName, AccountCreate -Force -Restart -ErrorAction Stop
} catch {Write-Warning 'unable to add to the domain.'}

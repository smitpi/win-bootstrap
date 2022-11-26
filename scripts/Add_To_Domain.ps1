
If (!(Get-CimInstance -Class Win32_ComputerSystem).PartOfDomain) {
    Write-Host -ForegroundColor Red "This machine is not part of a domain. Adding now."
    $user = Read-Host "Userid"
    $pass = Read-Host "Password" -AsSecureString
	$labcred = New-Object System.Management.Automation.PSCredential ($user,$pass)
    
    Rename-Computer -ComputerName $env:COMPUTERNAME -NewName "Dev-$(get-random -Maximum 5000)"
    Start-Sleep 5
    Add-Computer -DomainName 'internal.lab' -Credential $labcred -Options JoinWithNewName,AccountCreate -Force
    invoke-reboot
}

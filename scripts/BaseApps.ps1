$common = "--cache-location=$($chocoCachePath) --yes --limit-output --no-progress --source=chocolatey"

choco upgrade bandizip $common
choco upgrade cascadia-code-nerd-font $common
choco upgrade cascadiacodepl $common
choco upgrade GoogleChrome $common
choco upgrade microsoft-edge $common
choco upgrade microsoft-windows-terminal $common
choco upgrade pwsh $common
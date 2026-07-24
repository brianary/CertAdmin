# VHS https://github.com/charmbracelet/vhs
Output demo.gif
Hide
Set Shell pwsh
Type "Import-Module (Resolve-Path ../src/bin/*/net*/publish/*.psd1)"
Enter
Type "Clear-Host"
Enter
Show
Type "Find-Certificate -FindV"
Tab
Type " localhost -FindT"
Tab
Type " *subjectn"
Tab
Type " -StoreN"
Tab
Type " My -StoreL"
Tab
Type " curr"
Tab
Type " |Tee-Object -Variable cert"
Enter
Sleep 3s
Type "$cert |Get-CertificatePermissions |Format-Table -AutoSize"
Enter
Sleep 3s
Type "$cert |Grant-CertificateAccess Guest"
Enter
Sleep 1s
Type "$cert |Get-CertificatePermissions |Format-Table -AutoSize"
Enter
Sleep 3s
Type "$cert |Revoke-CertificateAccess Guest"
Enter
Sleep 1s
Type "$cert |Get-CertificatePermissions |Format-Table -AutoSize"
Enter
Sleep 3s
Type "$cert |Get-CertificatePath"
Enter
Sleep 3s

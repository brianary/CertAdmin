# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'CertAdmin.dll'
ModuleVersion = '1.1.7'
CompatiblePSEditions = @('Core')
GUID = 'e2c74aef-6c13-4b09-b6e3-feb8b47d4e64'
Author = 'Brian Lalonde'
#CompanyName = 'Unknown'
Copyright = '(c) Brian Lalonde. All rights reserved.'
Description = 'Manage certificates and their permissions on a Windows server.'
PowerShellVersion = '5.1'
FunctionsToExport = @()
CmdletsToExport = @(
    'Block-CertificateAccess'
    'Disable-Certificate'
    'Enable-Certificate'
    'Find-Certificate'
    'Get-CertificatePath'
    'Get-CertificatePermissions'
    'Grant-CertificateAccess'
    'Revoke-CertificateAccess'
    'Unblock-CertificateAccess'
)
VariablesToExport = @()
AliasesToExport = @()
FileList = @('CertAdmin.dll','CertAdmin.dll-Help.xml')
PrivateData = @{
    PSData = @{
        Tags = @('X509','certificate','permissions','Windows')
        LicenseUri = 'https://github.com/brianary/CertAdmin/blob/master/LICENSE'
        ProjectUri = 'https://github.com/brianary/CertAdmin/'
        IconUri = 'http://webcoder.info/images/CertAdmin.svg'
        # ReleaseNotes = ''
    }
}
}

# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'CertAdmin.dll'
ModuleVersion = '1.0.0'
CompatiblePSEditions = @('Core')
GUID = 'e2c74aef-6c13-4b09-b6e3-feb8b47d4e64'
Author = 'Brian Lalonde'
#CompanyName = 'Unknown'
Copyright = '(c) Brian Lalonde. All rights reserved.'
Description = 'A description of this module template.'
PowerShellVersion = '6.0'
FunctionsToExport = @()
CmdletsToExport = @('Disable-Certificate','Enable-Certificate','Find-Certificate')
VariablesToExport = @()
AliasesToExport = @()
FileList = @('CertAdmin.dll','CertAdmin.dll-Help.xml')
PrivateData = @{
    PSData = @{
        Tags = @('X509','certificate','permissions')
        # LicenseUri = ''
        # ProjectUri = ''
        # IconUri = ''
        # ReleaseNotes = ''
    }
}
}

# Pester tests, see https://github.com/Pester/Pester/wiki
$envPath = $env:Path # avoid testing the wrong cmdlets
$module = Import-Module (Resolve-Path ./src/*/bin/Debug/*/*.psd1) -PassThru -vb
Import-LocalizedData -BindingVariable manifest -BaseDirectory ./src/* -FileName (Split-Path $PWD -Leaf)
$guest = "$env:COMPUTERNAME\Guest"
$notAdmin = !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
    IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$pkcerts = Get-ChildItem Cert:\CurrentUser\My |Where-Object {$_.HasPrivateKey}

function Global:Test-HasAccess($Who,$Path,$AccessType)
{
    [bool]((Get-Acl $Path).Access |
        Where-Object {$_.IdentityReference -eq $Who -and
            $_.AccessControlType -eq $AccessType -and
            $_.FileSystemRights.HasFlag([Security.AccessControl.FileSystemRights]'Read')})
}
Describe $module.Name {
    Context "$($module.Name) module" -Tag Module {
        It "Given the module, the version should match the manifest version" {
            $module.Version |Should -BeExactly $manifest.ModuleVersion
        }
		It "Given the module, the DLL file version should match the manifest version" {
            (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.FileVersionRaw |
                Should -BeLike "$($manifest.ModuleVersion)*"
		}
		It "Given the module, the DLL product version should match the manifest version" {
            (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.ProductVersionRaw |
                Should -BeLike "$($manifest.ModuleVersion)*"
		} -Pending
		It "Given the module, the DLL should have a valid semantic product version" {
			$v = (Get-Item "$($module.ModuleBase)\$($module.Name).dll").VersionInfo.ProductVersion
			[semver]::TryParse($v, [ref]$null) |Should -BeTrue
		} -Pending
    }
    Context 'Disable-Certificate cmdlet' {
        It "Certificate Archived property is set" {
            $cert = Get-ChildItem Cert:\CurrentUser\Root |
                where {$_.NotAfter -lt (Get-Date) -and !$_.Archived} |
                select -First 1
            if($notAdmin) {Set-ItResult -Inconclusive -Because 'this process is not running as admin'}
            elseif(!$cert) {Set-ItResult -Inconclusive -Because 'no certs were found to test'}
            else
            {
                $cert |Disable-Certificate
                $cert.Archived |Should -BeTrue
                $cert.Archived = $false
            }
        }
    }
    Context 'Enable-Certificate cmdlet' {
        It "Certificate Archived property is not set" {
            $cert = Get-ChildItem Cert:\CurrentUser\Root |
                where {$_.NotAfter -lt (Get-Date) -and !$_.Archived} |
                select -First 1
            if($notAdmin) {Set-ItResult -Inconclusive -Because 'this process is not running as admin'}
            elseif(!$cert) {Set-ItResult -Inconclusive -Because 'no certs were found to test'}
            else
            {
                $cert.Archived = $true
                $cert |Enable-Certificate
                $cert.Archived |Should -BeFalse
            }
        }
    }
    Context 'Find-Certificate cmdlet' {
        It "Find '<FindValue>' by '<FindType>' in '<StoreLocation>\<StoreName>' should be returned" -TestCases @(
            @{ FindValue = ' '; FindType = 'FindBySubjectName'; StoreLocation = 'LocalMachine'; StoreName = 'AuthRoot' }
        ) {
            Param($FindValue,$FindType,$StoreLocation,$StoreName)
            $certs = Find-Certificate $FindValue $FindType $StoreName $StoreLocation
            $certs.Count | Should -BeGreaterOrEqual 1
            $certs |Should -BeOfType [System.Security.Cryptography.X509Certificates.X509Certificate2]
        }
    }
    $certparams = $pkcerts| ForEach-Object {@{
        Certificate = $_
        Subject     = $_.Subject
        Thumbprint  = $_.Thumbprint
        Path        = $_ |Get-CertificatePath
    }}
    Context 'Get-CertificatePath cmdlet' {
        It "Find certificate private key path for '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            $Path |Should -Not -BeNullOrEmpty -Because 'a path value should be returned'
            $Path |Should -Exist -Because 'the private key file should exist'
        } -Skip:(!$pkcerts)
    }
    Context 'Get-CertificatePermissions cmdlet' {
        It "Get certificate private key permissions for '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint)
            [object[]]$perms = $Certificate |Get-CertificatePermissions
            $perms.Length |Should -BeGreaterThan 0 -Because 'the certificate should have permissions'
        } -Skip:(!$pkcerts)
    }
    Context 'Grant-CertificateAccess cmdlet' {
        It "Grant $guest access to certificate '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            if(Test-HasAccess $guest $Path 'Allow')
            {
                Set-ItResult -Inconclusive -Because "$guest already has access to $Path"
            }
            else
            {
                $Certificate |Grant-CertificateAccess -UserName $guest
                Test-HasAccess $guest $Path 'Allow' |Should -BeTrue
            }
        }
    }
    Context 'Revoke-CertificateAccess cmdlet' {
        It "Revoke $guest access to certificate '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            if(!(Test-HasAccess $guest $Path 'Allow'))
            {
                Set-ItResult -Inconclusive -Because "$guest doesn't have access to $Path"
            }
            else
            {
                $Certificate |Revoke-CertificateAccess -UserName $guest
                Test-HasAccess $guest $Path 'Allow' |Should -BeFalse
            }
        }
    }
    Context 'Block-CertificateAccess cmdlet' {
        It "Deny $guest access to certificate '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            if(Test-HasAccess $guest $Path 'Deny')
            {
                Set-ItResult -Inconclusive -Because "$guest already has blocked access to $Path"
            }
            else
            {
                $Certificate |Block-CertificateAccess -UserName $guest
                Test-HasAccess $guest $Path 'Deny' |Should -BeTrue
            }
        }
    }
    Context 'Unblock-CertificateAccess cmdlet' {
        It "Rescind blocked $guest access to certificate '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            if(!(Test-HasAccess $guest $Path 'Deny'))
            {
                Set-ItResult -Inconclusive -Because "$guest doesn't have blocked access to $Path"
            }
            else
            {
                $Certificate |Unblock-CertificateAccess -UserName $guest
                Test-HasAccess $guest $Path 'Deny' |Should -BeFalse
            }
        }
    }
}.GetNewClosure()
$env:Path = $envPath

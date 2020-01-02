Import-Module (Resolve-Path ./src/*/bin/Debug/*/*.psd1) -vb
$everyone = "$env:COMPUTERNAME\Everyone"
$guest = [Security.Principal.WindowsBuiltInRole]::Guest
$notAdmin = !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
    IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$pkcerts = Get-ChildItem Cert:\CurrentUser\My |Where-Object {$_.HasPrivateKey}

function Test-HasAccess($Who,$Path,$AccessType)
{
    [bool]((Get-Acl $Path).Access |
        Where-Object {$_.IdentityReference -eq $Who -and
            $_.AccessControlType -eq $AccessType -and
            $_.FileSystemRights.HasFlag([Security.AccessControl.FileSystemRights]'Read')})
}
Describe 'CertAdmin' {
    Context 'CertAdmin module' {
        It "Given the CertAdmin module, it should have a nonzero version" {
            $m = Get-Module CertAdmin
            $m.Version |Should -Not -Be $null
            $m.Version.Major |Should -BeGreaterThan 0
        }
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
            @{ FindValue = 'Microsoft'; FindType = 'FindBySubjectName'; StoreLocation = 'LocalMachine'; StoreName = 'AuthRoot' }
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
    #TODO: Permissions testing needs work.
    Context 'Grant-CertificateAccess cmdlet' {
        It "Grant everyone access to certificate  '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            if(Test-HasAccess $everyone $Path 'Allow')
            {
                Set-ItResult -Inconclusive -Because "$everyone already has access to $Path"
            }
            else
            {
                $Certificate |Grant-CertificateAccess -UserName $everyone
                Test-HasAccess $everyone $Path 'Allow' |Should -BeTrue
            }
        } -Skip
    }
    Context 'Revoke-CertificateAccess cmdlet' {
        It "Revoke everyone's access to certificate  '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            if(!(Test-HasAccess $everyone $Path 'Allow'))
            {
                Set-ItResult -Inconclusive -Because "$everyone doesn''t have access to $Path"
            }
            else
            {
                $Certificate |Revoke-CertificateAccess -UserName $everyone
                Test-HasAccess $everyone $Path 'Allow' |Should -BeFalse
            }
        } -Skip
    }
    Context 'Block-CertificateAccess cmdlet' {
        It "Deny guest access to certificate  '<Subject>' (<Thumbprint>)" -TestCases $certparams {
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
        } -Skip
    }
    Context 'Unblock-CertificateAccess cmdlet' {
        It "Rescind blocked guest access to certificate  '<Subject>' (<Thumbprint>)" -TestCases $certparams {
            Param($Certificate,$Subject,$Thumbprint,$Path)
            if(!(Test-HasAccess $guest $Path 'Deny'))
            {
                Set-ItResult -Inconclusive -Because "$guest doesn''t have blocked access to $Path"
            }
            else
            {
                $Certificate |Unblock-CertificateAccess -UserName $guest
                Test-HasAccess $guest $Path 'Deny' |Should -BeFalse
            }
        } -Skip
    }
}

Import-Module (Resolve-Path ./src/*/bin/Debug/*/*.psd1) -vb
$notAdmin = !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
    IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
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
}

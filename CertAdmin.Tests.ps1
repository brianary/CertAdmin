Import-Module (Resolve-Path ./src/*/bin/Debug/*/*.psd1) -vb
Describe 'CertAdmin' {
    Context 'CertAdmin module' {
        It "Given the CertAdmin module, it should have a nonzero version" {
            $m = Get-Module CertAdmin
            $m.Version |Should -Not -Be $null
            $m.Version.Major |Should -BeGreaterThan 0
        }
    }
    Context 'Find-Certificate cmdlet' {
        It "Find '<FindValue>' by '<FindType>' in '<StoreLocation>\<StoreName>' should be returned." -TestCases @(
            @{ FindValue = 'Microsoft'; FindType = 'FindBySubjectName'; StoreLocation = 'LocalMachine'; StoreName = 'AuthRoot' }
        ) {
            Param($FindValue,$FindType,$StoreLocation,$StoreName)
            $certs = Find-Certificate $FindValue $FindType $StoreName $StoreLocation
            $certs.Count | Should -BeGreaterOrEqual 1
            $certs |Should -BeOfType [System.Security.Cryptography.X509Certificates.X509Certificate2]
        }
    }
}

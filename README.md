CertAdmin
================

<!-- To publish to PowerShell Gallery: dotnet build -t:PublishModule -c Release -->
<!-- img src="CertAdmin.svg" alt="CertAdmin icon" align="right" / -->

Manage certificates and their permissions on a Windows server.

Cmdlets
-------

Documentation is automatically generated using [platyPS](https://github.com/PowerShell/platyPS).

- [Disable-Certificate](docs/Disable-Certificate.md)
- [Enable-Certificate](docs/Enable-Certificate.md)
- [Find-Certificate](docs/Find-Certificate.md)
- [Get-CertificatePrivateKeyPath](docs/Get-CertificatePrivateKeyPath.md)

Tests
-----

Tests are written for [Pester](https://github.com/Pester/Pester).

To run the tests, run `dotnet build -t:pester`.

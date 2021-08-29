CertAdmin
================

<!-- To publish to PowerShell Gallery: dotnet build -t:PublishModule -c Release -->
<img src="CertAdmin.svg" alt="CertAdmin icon" align="right" />

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/CertAdmin)](https://www.powershellgallery.com/packages/CertAdmin/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/CertAdmin)](https://www.powershellgallery.com/packages/CertAdmin/)
[![Actions Status](https://github.com/brianary/CertAdmin/workflows/.NET%20Core/badge.svg)](https://github.com/brianary/CertAdmin/actions)

Manage certificates and their permissions on a Windows server.

![example usage of CertAdmin](CertAdmin.gif)

Cmdlets
-------

Documentation is automatically generated using [platyPS](https://github.com/PowerShell/platyPS) (`.\doc.cmd`).

- [Block-CertificateAccess](docs/Block-CertificateAccess.md) &mdash;
  Denies a user or an IIS app pool access to a certificate's private key.
- [Disable-Certificate](docs/Disable-Certificate.md) &mdash;
  Sets the Archived property on a certificate.
- [Enable-Certificate](docs/Enable-Certificate.md) &mdash;
  Unsets the Archived property on a certificate.
- [Find-Certificate](docs/Find-Certificate.md) &mdash;
  Searches a certificate store for certificates.
- [Get-CertificatePath](docs/Get-CertificatePath.md) &mdash;
  Gets the physical path on disk of a certificate's private key.
- [Grant-CertificateAccess](docs/Grant-CertificateAccess.md) &mdash;
  Gives a user or an IIS app pool access to a certificate's private key.
- [Revoke-CertificateAccess](docs/Revoke-CertificateAccess.md) &mdash;
  Revokes a user or an IIS app pool access to a certificate's private key.
- [Unblock-CertificateAccess](docs/Unblock-CertificateAccess.md) &mdash;
  Rescinds a denied user or an IIS app pool access to a certificate's private key.

Tests
-----

Tests are written for [Pester](https://github.com/Pester/Pester) (`.\test.cmd`).

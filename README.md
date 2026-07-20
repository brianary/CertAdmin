CertAdmin
================

<img src="images/CertAdmin.svg" alt="CertAdmin icon" align="right" />

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/CertAdmin)](https://www.powershellgallery.com/packages/CertAdmin/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/CertAdmin)](https://www.powershellgallery.com/packages/CertAdmin/)
[![PowerShell Gallery Platform](https://img.shields.io/powershellgallery/p/CertAdmin)](https://www.powershellgallery.com/packages/CertAdmin/)
[![🩺 Continuous integration ⏩](https://github.com/brianary/CertAdmin/actions/workflows/continuous.yml/badge.svg)](https://github.com/brianary/CertAdmin/actions/workflows/continuous.yml)

Manage certificates and their permissions on a Windows server.

To install: `Install-Module CertAdmin`

![example usage of CertAdmin](images/CertAdmin.gif)

Cmdlets
-------

Documentation is automatically generated using [platyPS](https://github.com/PowerShell/platyPS) (`.\doc.cmd`).

- [Block-CertificateAccess](https://github.com/brianary/CertAdmin/wiki/Block-CertificateAccess) &mdash;
  Denies a user or an IIS app pool access to a certificate's private key.
- [Disable-Certificate](https://github.com/brianary/CertAdmin/wiki/Disable-Certificate) &mdash;
  Sets the Archived property on a certificate.
- [Enable-Certificate](https://github.com/brianary/CertAdmin/wiki/Enable-Certificate) &mdash;
  Unsets the Archived property on a certificate.
- [Find-Certificate](https://github.com/brianary/CertAdmin/wiki/Find-Certificate) &mdash;
  Searches a certificate store for certificates.
- [Get-CertificatePath](https://github.com/brianary/CertAdmin/wiki/Get-CertificatePath) &mdash;
  Gets the physical path on disk of a certificate's private key.
- [Grant-CertificateAccess](https://github.com/brianary/CertAdmin/wiki/Grant-CertificateAccess) &mdash;
  Gives a user or an IIS app pool access to a certificate's private key.
- [Revoke-CertificateAccess](https://github.com/brianary/CertAdmin/wiki/Revoke-CertificateAccess) &mdash;
  Revokes a user or an IIS app pool access to a certificate's private key.
- [Unblock-CertificateAccess](https://github.com/brianary/CertAdmin/wiki/Unblock-CertificateAccess) &mdash;
  Rescinds a denied user or an IIS app pool access to a certificate's private key.

Tests
-----

Tests are written for [Pester](https://github.com/Pester/Pester) (`.\test.cmd`).

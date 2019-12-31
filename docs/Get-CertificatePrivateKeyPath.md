---
external help file: CertAdmin.dll-Help.xml
Module Name: CertAdmin
online version: https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx
schema: 2.0.0
---

# Get-CertificatePrivateKeyPath

## SYNOPSIS
Gets the physical path on disk of a certificate's private key.

## SYNTAX

```
Get-CertificatePrivateKeyPath [-Certificate] <X509Certificate2> [<CommonParameters>]
```

## DESCRIPTION
Getting a certificate's private key path is important when managing the access permissions to that certificate.
For example, IIS web applications that require a client certificate to communicate to other web services will
need explicit access to the file granted or accessing the certificate will fail with a cryptic, unhelpful error.

## EXAMPLES

### Example 1
```powershell
PS C:\> Find-Certificate.ps1 localhost FindBySubjectName My LocalMachine |Get-CertificatePath.ps1

C:\ProgramData\Microsoft\crypto\rsa\machinekeys\abd662b361941f26a1173357adb3c12d_b4d34fe9-d85e-45e3-83dd-a52fa93c8551
```

A certificate is found, and the location of the private key on disk is returned.

## PARAMETERS

### -Certificate
A certificate in the Windows Certificate Store.

```yaml
Type: X509Certificate2
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Security.Cryptography.X509Certificates.X509Certificate2

## OUTPUTS

### System.String

## NOTES

## RELATED LINKS

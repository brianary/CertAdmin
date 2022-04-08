---
external help file: CertAdmin.dll-Help.xml
Module Name: CertAdmin
online version: https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx
schema: 2.0.0
---

# Get-CertificatePermissions

## SYNOPSIS
Returns the permissions of a certificate's private key file.

## SYNTAX

```
Get-CertificatePermissions [-Certificate] <X509Certificate2> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CertificatePermissions -Certificate $cert
```

Returns the permissions for the certificate in $cert.

### Example 2
```powershell
PS C:\> Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Get-CertificatePermissions
```

Returns the permissions for the certificate.

### Example 3
```powershell
PS C:\> $c = Find-Certificate.ps1 ExampleCert FindBySubjectName TrustedPeople LocalMachine ; Get-CertificatePermissions.ps1 $c
```

Another approach to get cert permissions.

## PARAMETERS

### -Certificate
The certificate to display permissions for.

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

### System.Object
## NOTES

## RELATED LINKS

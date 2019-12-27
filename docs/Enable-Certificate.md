---
external help file: CertAdmin.dll-Help.xml
Module Name: CertAdmin
online version:
schema: 2.0.0
---

# Enable-Certificate

## SYNOPSIS
Unsets the Archived property on a certificate.

## SYNTAX

```
Enable-Certificate [-Certificate] <X509Certificate2> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Clearing the Archived property allows you to enable a certificate without having to re-import it,
for software that excludes Archived certificates.

## EXAMPLES

### EXAMPLE 1
```
Enable-Certificate.ps1 -Certificate $cert
```

Sets $cert.Archived to $false.

### EXAMPLE 2
```
Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Enable-Certificate.ps1
```

Sets the found ExampleCert as not archived.

For more information about options for -FindType:
https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx

### EXAMPLE 3
```
Get-Item Cert:\CurrentUser\My\F397B30796BE1E1D11C34B6893A2F035844FD936 |Enable-Certificate.ps1
```

Sets the certificate as not archived.

## PARAMETERS

### -Certificate
The certificate to un-archive.

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

### -WhatIf
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Security.Cryptography.X509Certificates.X509Certificate2 to set unmark as Archived.
### System.Security.Cryptography.X509Certificates.X509Certificate2

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Find-Certificate.ps1]()

[https://docs.microsoft.com/dotnet/api/system.security.cryptography.x509certificates.x509certificate2.archived](https://docs.microsoft.com/dotnet/api/system.security.cryptography.x509certificates.x509certificate2.archived)

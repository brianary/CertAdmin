---
external help file: CertAdmin.dll-Help.xml
Module Name: CertAdmin
online version:
schema: 2.0.0
---

# Disable-Certificate

## SYNOPSIS
Sets the Archived property on a certificate.

## SYNTAX

```
Disable-Certificate [-Certificate] <X509Certificate2> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Setting the Archived property allows you to disable a certificate without deleting it,
for software that excludes Archived certificates.

## EXAMPLES

### EXAMPLE 1
```
Disable-Certificate -Certificate $cert
```

Sets $cert.Archived to $true.

### EXAMPLE 2
```
Find-Certificate -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Disable-Certificate
```

Sets the found ExampleCert as archived.

For more information about options for -FindType:
https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx

### EXAMPLE 3
```
Get-Item Cert:\CurrentUser\My\F397B30796BE1E1D11C34B6893A2F035844FD936 |Disable-Certificate
```

Sets the certificate as archived.

## PARAMETERS

### -Certificate
The certificate to archive.

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

### System.Security.Cryptography.X509Certificates.X509Certificate2 to set as Archived.
### System.Security.Cryptography.X509Certificates.X509Certificate2

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.security.cryptography.x509certificates.x509certificate2.archived](https://docs.microsoft.com/dotnet/api/system.security.cryptography.x509certificates.x509certificate2.archived)

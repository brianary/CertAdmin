---
external help file: CertAdmin.dll-Help.xml
Module Name: CertAdmin
online version: https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx
schema: 2.0.0
---

# Unblock-CertificateAccess

## SYNOPSIS
Rescinds a denied user or an IIS app pool access to a certificate's private key.

## SYNTAX

### UserName
```
Unblock-CertificateAccess [-UserName] <String> [-Certificate] <X509Certificate2> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### AppPool
```
Unblock-CertificateAccess -AppPool <String> [-Certificate] <X509Certificate2> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This will rescind denied access to a certificate's private key file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Block-CertificateAccess.ps1 -AppPool ExampleAppPool -Certificate $cert
```

Revokes the denied ExampleAppPool app pool access to read the cert in $cert.

### Example 2
```powershell
PS C:\> Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Block-CertificateAccess.ps1 ExampleAppPool
```

Revokes the denied ExampleAppPool app pool access to read the found ExampleCert.

## PARAMETERS

### -AppPool
The name of an IIS app pool.

```yaml
Type: String
Parameter Sets: AppPool
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Certificate
A certificate from the Windows Certificate Store.

```yaml
Type: X509Certificate2
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

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

### -UserName
A Windows domain account.

```yaml
Type: String
Parameter Sets: UserName
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Security.Cryptography.X509Certificates.X509Certificate2

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

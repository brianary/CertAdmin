---
external help file: CertAdmin.dll-Help.xml
Module Name: CertAdmin
online version:
schema: 2.0.0
---

# Block-CertificateAccess

## SYNOPSIS
Denies a user or an IIS app pool access to a certificate's private key.

## SYNTAX

### UserName
```
Block-CertificateAccess [-UserName] <String> [-Certificate] <X509Certificate2> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### AppPool
```
Block-CertificateAccess -AppPool <String> [-Certificate] <X509Certificate2> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
This will explicitly block access to a certificate's private key file, in case you want to
test a user or app pool's dependence on it, or aggressively protect it.

## EXAMPLES

### Example 1
```powershell
PS C:\> Block-CertificateAccess -AppPool ExampleAppPool -Certificate $cert
```

Denies the ExampleAppPool app pool access to read the cert in $cert.

### Example 2
```powershell
PS C:\> Find-Certificate -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine |Block-CertificateAccess ExampleAppPool
```

Denies the ExampleAppPool app pool access to read the found ExampleCert.

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

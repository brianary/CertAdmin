---
external help file: CertAdmin.dll-Help.xml
Module Name: CertAdmin
online version:
schema: 2.0.0
---

# Find-Certificate

## SYNOPSIS
Searches a certificate store for certificates.

## SYNTAX

```
Find-Certificate [-FindValue] <Object> [[-FindType] <X509FindType>] [[-StoreName] <StoreName>]
 [[-StoreLocation] <StoreLocation>] [-Valid] [-NotArchived] [-Require] [<CommonParameters>]
```

## DESCRIPTION
Searches for certificates in the Windows Certificate Store.

## EXAMPLES

### Example 1
```powershell
PS C:\> Find-Certificate.ps1 -FindValue ExampleCert -FindType FindBySubjectName -StoreName TrustedPeople -StoreLocation LocalMachine
```

Searches Cert:\LocalMachine\TrustedPeople for a certificate with a subject name of "ExampleCert".

### Example 2
```powershell
Find-Certificate.ps1 ExampleCert FindBySubjectName TrustedPeople LocalMachine
```

Uses positional parameters to search Cert:\LocalMachine\TrustedPeople for a cert with subject of "ExampleCert".

## PARAMETERS

### -FindValue
The value to search for, usually a string.

For a FindType of FindByTimeValid, FindByTimeNotYetValid, or FindByTimeExpired, the FindValue must be a datetime.
For a FindType of FindByApplicationPolicy or FindByCertificatePolicy, the FindValue can be a string or a
System.Security.Cryptography.Oid.
For a FindType of FindByKeyUsage, the FindValue can be a string or an int bitmask.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Value

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FindType
The field of the certificate to compare to FindValue.
e.g. FindBySubjectName, FindByKeyUsage, FindByIssuerDistinguishedName

For a FindType of FindByTimeValid, FindByTimeNotYetValid, or FindByTimeExpired, the FindValue should be a datetime.
For a FindType of FindByApplicationPolicy or FindByCertificatePolicy, the FindValue can be a string or a
System.Security.Cryptography.Oid.
For a FindType of FindByKeyUsage, the FindValue can be a string or an int bitmask.

Omitting a FindType or StoreName will search all stores and common fields.

```yaml
Type: X509FindType
Parameter Sets: (All)
Aliases: Type, Field
Accepted values: FindByThumbprint, FindBySubjectName, FindBySubjectDistinguishedName, FindByIssuerName, FindByIssuerDistinguishedName, FindBySerialNumber, FindByTimeValid, FindByTimeNotYetValid, FindByTimeExpired, FindByTemplateName, FindByApplicationPolicy, FindByCertificatePolicy, FindByExtension, FindByKeyUsage, FindBySubjectKeyIdentifier

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StoreName
The name of the certificate store to search.
e.g. My, TrustedPeople, Root

Omitting a FindType or StoreName will search all stores and common fields.

```yaml
Type: StoreName
Parameter Sets: (All)
Aliases:
Accepted values: AddressBook, AuthRoot, CertificateAuthority, Disallowed, My, Root, TrustedPeople, TrustedPublisher

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StoreLocation
Whether to search the certificates of the CurrentUser or the LocalMachine.

```yaml
Type: StoreLocation
Parameter Sets: (All)
Aliases:
Accepted values: CurrentUser, LocalMachine

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Valid
Whether to further filter search results by checking the effective and expiration dates.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NotArchived
Whether to further filter search results by excluding certificates marked as archived.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Require
Whether to throw an error if a certificate is not found.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Security.Cryptography.X509Certificates.X509Certificate2[]

## NOTES

## RELATED LINKS

[X509FindType](https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509findtype.aspx)

[X509Store](https://msdn.microsoft.com/library/ms148581.aspx)

[X509Certificate2](https://msdn.microsoft.com/library/system.security.cryptography.x509certificates.x509certificate2.aspx)

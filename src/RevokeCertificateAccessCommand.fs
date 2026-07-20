namespace CertAdmin

open System.Management.Automation
open System.Security.AccessControl

/// Removes user or app pool access to a certificate's private key.
[<Cmdlet(VerbsSecurity.Revoke, "CertificateAccess", ConfirmImpact=ConfirmImpact.Medium, SupportsShouldProcess=true)>]
type RevokeCertificateAccessCommand () =
    inherit GrantCertificateAccessCommand ()

    override x.ProcessRecord () =
        x.ChangePermissions AccessControlType.Allow false

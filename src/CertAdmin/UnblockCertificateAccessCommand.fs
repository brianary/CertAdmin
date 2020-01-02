namespace CertAdmin

open System.Management.Automation
open System.Security.AccessControl

/// Removes user or app pool denial of a certificate's private key.
[<Cmdlet(VerbsSecurity.Unblock, "CertificateAccess", ConfirmImpact=ConfirmImpact.Medium, SupportsShouldProcess=true)>]
type UnblockCertificateAccessCommand () =
    inherit GrantCertificateAccessCommand ()

    override x.ProcessRecord () =
        x.ChangePermissions AccessControlType.Deny false

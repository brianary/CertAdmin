namespace CertAdmin

open System.Management.Automation
open System.Security.AccessControl

/// Denies a user or app pool access to a certificate's private key.
[<Cmdlet(VerbsSecurity.Block, "CertificateAccess", ConfirmImpact=ConfirmImpact.Medium, SupportsShouldProcess=true)>]
type BlockCertificateAccessCommand () =
    inherit GrantCertificateAccessCommand ()

    override x.ProcessRecord () =
        x.ChangePermissions AccessControlType.Deny true

namespace CertAdmin

open System
open System.Management.Automation
open System.Security.Cryptography.X509Certificates

/// Unsets the Archived property on a certificate.
[<Cmdlet(VerbsLifecycle.Enable, "Certificate",ConfirmImpact=ConfirmImpact.Medium,SupportsShouldProcess=true)>]
type EnableCertificateCommand () =
    inherit PSCmdlet ()

    /// The certificate to un-archive.
    [<Parameter(Position=0,Mandatory=true,ValueFromPipeline=true)>]
    [<ValidateNotNullOrEmpty>]
    member val Certificate : X509Certificate2 = null with get, set

    override x.ProcessRecord () =
        base.ProcessRecord ()
        x.Certificate.Archived <- false

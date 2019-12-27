namespace CertAdmin

open System
open System.Management.Automation
open System.Security.Cryptography.X509Certificates

/// Sets the Archived property on a certificate.
[<Cmdlet(VerbsLifecycle.Disable, "Certificate",ConfirmImpact=ConfirmImpact.Medium,SupportsShouldProcess=true)>]
type DisableCertificateCommand () =
    inherit PSCmdlet ()

    /// The certificate to archive.
    [<Parameter(Position=0,Mandatory=true,ValueFromPipeline=true)>]
    [<ValidateNotNullOrEmpty>]
    member val Certificate : X509Certificate2 = null with get, set

    override x.ProcessRecord () =
        base.ProcessRecord ()
        x.Certificate.Archived <- true

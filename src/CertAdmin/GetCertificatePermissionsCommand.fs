namespace CertAdmin

open System
open System.IO
open System.Linq
open System.Management.Automation
open System.Security.AccessControl
open System.Security.Cryptography.X509Certificates
open System.Security.Principal

/// Sets the Archived property on a certificate.
[<Cmdlet(VerbsCommon.Get, "CertificatePermissions", ConfirmImpact=ConfirmImpact.None)>]
type GetCertificatePermissionsCommand () =
    inherit PSCmdlet ()

    /// The certificate to archive.
    [<Parameter(Position=0,Mandatory=true,ValueFromPipeline=true)>]
    [<ValidateNotNullOrEmpty>]
    member val Certificate : X509Certificate2 = null with get, set

    /// Returns the filesystem permissions for a certificate's private key file.
    static member internal GetAccessControl cert =
        ((GetCertificatePathCommand.Invoke >> FileInfo) cert).GetAccessControl ()

    /// Sets the filesystem permissions for a certificate's private key file.
    static member internal SetAccessControl cert transform =
        let fileinfo = (GetCertificatePathCommand.Invoke >> FileInfo) cert
        let security = fileinfo.GetAccessControl ()
        transform security |> fileinfo.SetAccessControl

    override x.ProcessRecord () =
        base.ProcessRecord ()
        try
            x.WriteVerbose(sprintf "Permissions for certificate: %A" x.Certificate)
            (GetCertificatePermissionsCommand.GetAccessControl x.Certificate).
                GetAccessRules(true, true, typeof<NTAccount>).Cast<FileSystemAccessRule>()
                |> Seq.toList
                |> List.iter x.WriteObject
        with
        | :? ArgumentException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidArgument, x.Certificate))
        | :? InvalidOperationException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidOperation, x.Certificate))

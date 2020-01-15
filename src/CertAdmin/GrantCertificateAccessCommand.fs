namespace CertAdmin

open System
open System.IO
open System.Linq
open System.Management.Automation
open System.Security.AccessControl
open System.Security.Cryptography.X509Certificates
open System.Security.Principal

/// Allows a user or app pool access to a certificate's private key.
[<Cmdlet(VerbsSecurity.Grant, "CertificateAccess", ConfirmImpact=ConfirmImpact.Medium, SupportsShouldProcess=true)>]
type GrantCertificateAccessCommand () =
    inherit PSCmdlet ()

    /// The user to grant read access for.
    [<Parameter(ParameterSetName="UserName", Position=0, Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    member val UserName : string = null with get, set

    /// The app pool to grant read access for.
    [<Parameter(ParameterSetName="AppPool", Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    member val AppPool : string = null with get, set

    /// The certificate to archive.
    [<Parameter(Position=1,Mandatory=true,ValueFromPipeline=true)>]
    [<ValidateNotNullOrEmpty>]
    member val Certificate : X509Certificate2 = null with get, set

    /// Determines if the process is running as admin.
    static member internal IsAdministrator () =
        (WindowsIdentity.GetCurrent () |> WindowsPrincipal).IsInRole(WindowsBuiltInRole.Administrator)

    /// Ensure admins have access to grant access to machinekeys.
    static member internal EnsureAdminKeyAccess (cmdlet:PSCmdlet) =
        let admin = NTAccount @"BUILTIN\Administrators" :> IdentityReference
        let keysinfo = sprintf @"%s\Microsoft\Crypto" (Environment.GetEnvironmentVariable "ALLUSERSPROFILE") |> DirectoryInfo
        let security = keysinfo.GetAccessControl ()
        let rules = security.GetAccessRules(true, true, typeof<NTAccount>).Cast<FileSystemAccessRule> ()
        let isAdminFull (r:FileSystemAccessRule) =
            r.IdentityReference = admin
                && r.AccessControlType.HasFlag(AccessControlType.Allow)
                && r.FileSystemRights.HasFlag(FileSystemRights.FullControl)
        let hasAdminFull = Seq.tryFind isAdminFull >> Option.isSome
        if ((not << hasAdminFull) rules)
            && cmdlet.ShouldProcess(sprintf "Administrators full control of %s" keysinfo.FullName, "grant") then
            if security.GetOwner(typeof<NTAccount>) <> admin
                && cmdlet.ShouldProcess(sprintf "Administrators ownership of %s" keysinfo.FullName, "set") then
                sprintf "Granting Administrators ownership of %s" keysinfo.FullName |> cmdlet.WriteVerbose
                security.SetOwner admin
                keysinfo.SetAccessControl security
            sprintf "Granting Administrators full control of %s" keysinfo.FullName |> cmdlet.WriteVerbose
            FileSystemAccessRule(admin, FileSystemRights.FullControl, AccessControlType.Allow) |> security.AddAccessRule
            keysinfo.SetAccessControl security

    /// Change the permissions on a certificate's private key file to add or remove allow or deny access.
    member internal x.ChangePermissions controltype add =
        try
            if (not << GrantCertificateAccessCommand.IsAdministrator) () then
                x.WriteWarning "Not running as administrator. Permission changes may not succeed."
            let identity =
                if x.ParameterSetName = "AppPool" then
                    sprintf @"IIS AppPool\%s" x.AppPool
                elif not (x.UserName.Contains(@"\") || x.UserName.Contains(@"@")) then
                    sprintf @"%s\%s" (Environment.GetEnvironmentVariable "USERDOMAIN") x.UserName
                else
                    x.UserName
            if x.ShouldProcess(sprintf "%s access to %s" identity x.Certificate.Subject, string controltype) then
                GrantCertificateAccessCommand.EnsureAdminKeyAccess x
                GetCertificatePermissionsCommand.SetAccessControl x.Certificate
                    (fun security ->
                        FileSystemAccessRule(identity, FileSystemRights.Read, controltype)
                            |> (if add then security.AddAccessRule else security.RemoveAccessRuleSpecific)
                        sprintf "%A certificate permission for %s" controltype identity |> x.WriteVerbose
                        security)
        with
        | :? ArgumentException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidArgument, x.Certificate))
        | :? InvalidOperationException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidOperation, x.Certificate))

    default x.ProcessRecord () =
        base.ProcessRecord ()
        x.ChangePermissions AccessControlType.Allow true

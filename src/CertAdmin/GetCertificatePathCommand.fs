namespace CertAdmin

open System
open System.Diagnostics.CodeAnalysis
open System.IO
open System.Management.Automation
open System.Runtime.InteropServices
open System.Security
open System.Security.Cryptography
open System.Security.Cryptography.X509Certificates
open System.Security.Permissions
open Microsoft.Win32.SafeHandles

/// Gets the physical path on disk of a certificate's private key.
[<Cmdlet(VerbsCommon.Get, "CertificatePath", ConfirmImpact=ConfirmImpact.None)>]
[<OutputType(typeof<string>)>]
type GetCertificatePathCommand () =
    inherit PSCmdlet ()

    static let findCurrentUserFile filename =
        Directory.GetFiles(Environment.ExpandEnvironmentVariables(@"%APPDATA%\Microsoft\Crypto"),
                           filename, SearchOption.AllDirectories )
            |> Seq.tryHead

    static let findAnyUserFile filename =
        (DirectoryInfo @"C:\Users").GetDirectories()
            |> Seq.map (fun d -> Path.Combine( d.FullName, @"AppData\Roaming\Microsoft\Crypto" ))
            |> Seq.filter Directory.Exists
            |> Seq.collect (fun d -> Directory.GetFiles(d, filename, SearchOption.AllDirectories))
            |> Seq.tryHead

    static let findMachineFile filename =
        Directory.GetFiles(Environment.ExpandEnvironmentVariables(@"%ProgramData%\Microsoft\Crypto"),
                           filename, SearchOption.AllDirectories )
            |> Seq.tryHead

    [<DllImport("crypt32.dll", CallingConvention = CallingConvention.Cdecl)>]
    [<SuppressMessage("NameConventions", "NonPublicValuesNames")>]
    static extern SafeNCryptKeyHandle CertDuplicateCertificateContext(IntPtr certContext) // CERT_CONTEXT *
    [<DllImport("crypt32.dll", CallingConvention = CallingConvention.Cdecl, SetLastError = true)>]
    [<SuppressMessage("NameConventions", "NonPublicValuesNames")>]
    static extern [<MarshalAs(UnmanagedType.Bool)>] bool
        CryptAcquireCertificatePrivateKey(SafeNCryptKeyHandle  pCert,
                                          uint32 dwFlags,
                                          IntPtr pvReserved, // void *
                                          SafeNCryptKeyHandle& phCryptProvOrNCryptKey,
                                          int& dwKeySpec,
                                          [<MarshalAs(UnmanagedType.Bool)>] bool& pfCallerFreeProvOrNCryptKey)
    [<SecurityCritical>]
    [<SecurityPermission(SecurityAction.LinkDemand, UnmanagedCode = true)>]
    static member private GetCngUniqueKeyContainerName (certificate : X509Certificate2) =
        // Thanks VoronoiPotato and Drake Wu https://stackoverflow.com/a/59536972/54323
        let mutable privateKey : SafeNCryptKeyHandle = new SafeNCryptKeyHandle()
        let mutable keySpec = 0
        let mutable freeKey = true
        CryptAcquireCertificatePrivateKey(CertDuplicateCertificateContext(certificate.Handle),
                                          0x00040000u, // AcquireOnlyNCryptKeys
                                          IntPtr.Zero, &privateKey, &keySpec, &freeKey) |> ignore
        // https://github.com/MicrosoftArchive/clrsecurity/blob/master/Security.Cryptography/src/X509Certificates/X509Certificate2ExtensionMethods.cs#L58
        CngKey.Open(privateKey, CngKeyHandleOpenOptions.None).UniqueName

    /// The certificate to archive.
    [<Parameter(Position=0,Mandatory=true,ValueFromPipeline=true)>]
    [<ValidateNotNullOrEmpty>]
    member val Certificate : X509Certificate2 = null with get, set

    static member internal Invoke (cert:X509Certificate2) =
        if not cert.HasPrivateKey then
            invalidArg "Certificate" "Certificate does not have a private key."
        let filename =
            match
                try cert.PrivateKey :> obj with
                | :? CryptographicException as ex ->
                    invalidArg "Certificate" "Unable to access the private key for this certificate."
            with
            | :? ICspAsymmetricAlgorithm as key ->
                key.CspKeyContainerInfo.UniqueKeyContainerName
            | _ -> GetCertificatePathCommand.GetCngUniqueKeyContainerName cert
        if String.IsNullOrEmpty filename then
            invalidArg "Certificate" "Certificate is missing the private key filename."
        match findCurrentUserFile filename with
        | Some path -> path
        | None ->
            match findMachineFile filename with
            | Some path -> path
            | None ->
                match findAnyUserFile filename with
                | Some path -> path
                | None -> invalidOp "Unable to get certificate private key path."

    override x.ProcessRecord () =
        base.ProcessRecord ()
        try
            x.WriteVerbose(sprintf "For certificate: %A" x.Certificate)
            x.WriteObject(GetCertificatePathCommand.Invoke x.Certificate)
        with
        | :? ArgumentException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidArgument, x.Certificate))
        | :? InvalidOperationException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidOperation, x.Certificate))

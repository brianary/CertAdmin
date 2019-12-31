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

/// Sets the Archived property on a certificate.
[<Cmdlet(VerbsCommon.Get, "CertificatePrivateKeyPath")>]
[<OutputType(typeof<string>)>]
type GetCertificatePrivateKeyPathCommand () =
    inherit PSCmdlet ()

    static let findCurrentUserPrivateKeyFile filename =
        Directory.GetFiles(Environment.ExpandEnvironmentVariables(@"%APPDATA%\Microsoft\Crypto"),
                           filename, SearchOption.AllDirectories )
            |> Seq.tryHead

    static let findAnyUserPrivateKeyFile filename =
        (DirectoryInfo @"C:\Users").GetDirectories()
            |> Seq.map (fun d -> Path.Combine( d.FullName, @"AppData\Roaming\Microsoft\Crypto" ))
            |> Seq.filter Directory.Exists
            |> Seq.collect (fun d -> Directory.GetFiles(d, filename, SearchOption.AllDirectories))
            |> Seq.tryHead

    static let findMachinePrivateKeyFile filename =
        Directory.GetFiles(Environment.ExpandEnvironmentVariables(@"%ProgramData%\Microsoft\Crypto"),
                           filename, SearchOption.AllDirectories )
            |> Seq.tryHead

    [<DllImport("crypt32.dll", CallingConvention = CallingConvention.Cdecl)>]
    [<SuppressMessage("NameConventions", "NonPublicValuesNames")>]
    static extern SafeNCryptKeyHandle private CertDuplicateCertificateContext(IntPtr certContext) // CERT_CONTEXT *
    [<DllImport("crypt32.dll", CallingConvention = CallingConvention.Cdecl, SetLastError = true)>]
    [<SuppressMessage("NameConventions", "NonPublicValuesNames")>]
    static extern [<MarshalAs(UnmanagedType.Bool)>] bool private
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

    override x.ProcessRecord () =
        base.ProcessRecord ()
        try
            if not x.Certificate.HasPrivateKey then
                invalidArg "Certificate" "Certificate does not have a private key."
            let filename =
                match x.Certificate.PrivateKey :> obj with
                | :? ICspAsymmetricAlgorithm as key -> key.CspKeyContainerInfo.UniqueKeyContainerName
                | _ -> GetCertificatePrivateKeyPathCommand.GetCngUniqueKeyContainerName x.Certificate
            if String.IsNullOrEmpty filename then
                invalidArg "Certificate" "Certificate is missing the private key filename."
            match findCurrentUserPrivateKeyFile filename with
            | Some path -> x.WriteObject(path)
            | None ->
                match findMachinePrivateKeyFile filename with
                | Some path -> x.WriteObject(path)
                | None ->
                    x.WriteWarning "Searching more desperately for the certificate file."
                    match findAnyUserPrivateKeyFile filename with
                    | Some path -> x.WriteObject(path)
                    | None -> invalidOp "Unable to get certificate private key path."
        with
        | :? ArgumentException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidArgument, x.Certificate))
        | :? InvalidOperationException as exn ->
            x.WriteError(ErrorRecord(exn, exn.Message, ErrorCategory.InvalidOperation, x.Certificate))

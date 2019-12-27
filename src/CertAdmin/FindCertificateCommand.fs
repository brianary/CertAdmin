namespace CertAdmin

open System
open System.Management.Automation
open System.Security.Cryptography.X509Certificates

/// Searches a certificate store for certificates.
[<Cmdlet(VerbsCommon.Find, "Certificate")>]
[<OutputType(typeof<X509Certificate2[]>)>]
type FindCertificateCommand () =
    inherit PSCmdlet ()

    /// Search for certificates meeting certain criteria within a store.
    let find value findtype valid notarchived (store:X509Store) =
        store.Open(OpenFlags.OpenExistingOnly)
        let found = store.Certificates.Find(findtype,value,valid)
        store.Close()
        if notarchived then
            Seq.filter (fun i -> found.[i].Archived) [(found.Count-1)..0]
                |> Seq.iter (fun i -> found.RemoveAt(i))
        found

    /// The value to search for, usually a string.
    [<Parameter(Position=0,Mandatory=true)>]
    [<ValidateNotNullOrEmpty>]
    [<Alias("Value")>]
    member val FindValue : obj = "" :> obj with get, set

    /// The field of the certificate to compare to FindValue.
    [<Parameter(Position=1)>]
    [<Alias("Type","Field")>]
    member val FindType : X509FindType = enum<X509FindType>(-1) with get, set

    /// The name of the certificate store to search.
    [<Parameter(Position=2)>]
    member val StoreName : StoreName = enum<StoreName>(-1) with get, set

    /// Whether to search the certificates of the CurrentUser or the LocalMachine.
    [<Parameter(Position=3)>]
    member val StoreLocation : StoreLocation = StoreLocation.LocalMachine with get, set

    /// Whether to further filter search results by checking the effective and expiration dates.
    [<Parameter()>]
    member val Valid : SwitchParameter = (SwitchParameter false) with get, set

    /// Whether to further filter search results by excluding certificates marked as archived.
    [<Parameter()>]
    member val NotArchived : SwitchParameter = (SwitchParameter false) with get, set

    /// Whether to throw an error if a certificate is not found.
    [<Parameter()>]
    member val Require : SwitchParameter = (SwitchParameter false) with get, set

    override x.ProcessRecord () =
        base.ProcessRecord ()
        let certs =
            if not (Enum.IsDefined(typeof<StoreName>,x.StoreName)
                && Enum.IsDefined(typeof<X509FindType>,x.FindType)) then
                seq [ for location in [ for v in Enum.GetValues(typeof<StoreLocation>) -> v :?> StoreLocation ] do
                          for name in [ for v in Enum.GetValues(typeof<StoreName>) -> v :?> StoreName ] do
                              yield new X509Store(name,location) ]
                    |> Seq.map (find x.FindValue x.FindType x.Valid.IsPresent x.NotArchived.IsPresent)
                    |> Seq.reduce (fun a b -> a.AddRange(b); a)
            else
                new X509Store(x.StoreName,x.StoreLocation)
                    |> find x.FindValue x.FindType x.Valid.IsPresent x.NotArchived.IsPresent
        if x.Require.IsPresent && certs.Count = 0 then
            ErrorRecord( InvalidOperationException "Unable to find certificate",
                             sprintf "Unable to %A '%A' (%s) in %A\\%A" x.FindType x.FindValue
                                 (x.FindValue.GetType().Name) x.StoreLocation x.StoreName,
                             ErrorCategory.InvalidOperation, x.FindValue )
                |> (x :> Cmdlet).ThrowTerminatingError
        x.WriteObject(certs)

<#
.Synopsis
	Builds and publishes the module.
#>

#Requires -Version 3
[CmdletBinding()] Param()

Push-Location $PSScriptRoot

$ModuleName = Resolve-Path ./src/* |Split-Path -Leaf
Import-LocalizedData module -BaseDirectory (Resolve-Path ./src/*) -FileName "$ModuleName.psd1"
$err = 'Module manifest (.psd1) version does not match project (.fsproj) version.'
if($module.ModuleVersion -ne (Select-Xml '//Version/text()' (Resolve-Path ./src/*/*.fsproj)).Node.Value){throw $err}
dotnet publish -c Release
Copy-Item (Resolve-Path ./src/*/bin/Release/*/publish/FSharp.Core.dll) (Resolve-Path ./src/*/bin/Release/*/) -vb
Remove-Item (Resolve-Path ./src/*/bin/Release/*/) -Recurse -Force
$installpath = Join-Path ($env:PSModulePath -split ';' -like '*\Users\*') $ModuleName -add $module.ModuleVersion
Copy-Item (Resolve-Path ./src/*/bin/Release/*/*) $installpath -vb

Import-Module $ModuleName

$key = Get-CachedCredential.ps1 $ModuleName "Enter API key for $ModuleName"
Publish-Module -Name $ModuleName -NuGetApiKey $key.GetNetworkCredential().Password

Pop-Location

<#
.Synopsis
	Sets up storage for the API key.
#>

#Requires -Version 7
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param()
if(!(Get-SecretVault PowerShellGallery -ErrorAction SilentlyContinue))
{
	Register-SecretVault PowerShellGallery -ModuleName Microsoft.PowerShell.SecretStore
}
$name = [io.path]::GetFileNameWithoutExtension((Resolve-Path $PSScriptRoot\*\*\*.psd1))
if(!(Get-SecretInfo $name -Vault PowerShellGallery) -or $PSCmdlet.ShouldProcess('existing API key','update'))
{
	$apikey = Get-Credential $name -Message 'Enter API key'
	Set-Secret $apikey.UserName -SecureStringSecret $apikey.Password -Vault PowerShellGallery
}

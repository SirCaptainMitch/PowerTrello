function Set-TrelloConfiguration
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiKey,
	
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$AccessToken
	)
		
	if (-not (Test-Path -Path $RegistryKeyPath))
	{
		New-Item -Path ($RegistryKeyPath | Split-Path -Parent) -Name ($RegistryKeyPath | Split-Path -Leaf) | Out-Null
	}
	
	$values = 'APIKey', 'AccessToken'
	foreach ($val in $values)
	{
		if ((Get-Item $RegistryKeyPath).GetValue($val))
		{
			Write-Verbose "'$RegistryKeyPath\$val' already exists. Skipping."
		}
		else
		{
			Write-Verbose "Creating $RegistryKeyPath\$val"
			New-ItemProperty $RegistryKeyPath -Name $val -Value ((Get-Variable $val).Value) -Force | Out-Null
		}
	}
}
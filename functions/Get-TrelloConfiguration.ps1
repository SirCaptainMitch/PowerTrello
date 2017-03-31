function Get-TrelloConfiguration
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$RegistryKeyPath = "HKCU:\Software\$ProjectName"
	)
	
	$ErrorActionPreference = 'Stop'
	try
	{
		if (-not (Test-Path -Path $RegistryKeyPath))
		{
			Write-Verbose "No $ProjectName configuration found in registry"
		}
		else
		{
			$keyValues = Get-ItemProperty -Path $RegistryKeyPath
			$global:trelloConfig = [pscustomobject]@{
				'APIKey' = $keyValues.APIKey;
				'AccessToken' = $keyValues.AccessToken
				'String' = "key=$($keyValues.APIKey)&token=$($keyValues.AccessToken)"	
			}
			$trelloConfig
		}
	}
	catch
	{
		Write-Error $_.Exception.Message
	}
}

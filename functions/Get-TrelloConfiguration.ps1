function Get-TrelloConfiguration
{
	[CmdletBinding()]
	param
	(
	)
	
	$ErrorActionPreference = 'Stop'
	try
	{
		if ($trelloConfig -ne $null) 
		{ 
			return $global:trelloConfig
		} else { 
			Write-Warning "There is no trelloConfig variable, run Set-TrelloConfiguration"
		}
	}
	catch
	{
		Write-Error $_.Exception.Message
	}
}

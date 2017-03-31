function Set-TrelloCardList
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[Alias('Id')]
		[string]$CardId,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ListId
	)
	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try
		{
			$uri = "$baseUrl/cards/{0}?idList={1}&{2}" -f $CardId, $ListId, $trelloConfig.String
			Invoke-RestMethod -Uri $uri -Method Put
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}

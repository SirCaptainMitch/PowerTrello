function Add-TrelloCardMember
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[object]$Card,
	
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$MemberId
		
	)
	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try
		{
			if ($Card.idMembers)
			{
				throw 'Existing members found on card. This is not supported yet.'
			}
			else
			{
				$uri = "$baseUrl/cards/{0}?idMembers={1}&{2}" -f $Card.Id, $MemberId, $trelloConfig.String	
			}
			
			Invoke-RestMethod -Uri $uri -Method Put
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
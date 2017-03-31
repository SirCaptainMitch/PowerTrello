function Get-TrelloCardLabel
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[object]$Board
	)
	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try
		{
			$uri = "$baseUrl/boards/{0}/labels?{1}" -f $Board.Id, $trelloConfig.String
			Invoke-RestMethod -Uri $uri
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
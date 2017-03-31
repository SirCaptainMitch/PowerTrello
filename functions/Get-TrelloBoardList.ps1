function Get-TrelloBoardList
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[Alias('Id')]
		[string]$BoardId
		
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
	}
	process
	{
		try
		{
			# Invoke-RestMethod -Uri "$baseUrl/boards/$BoardId/lists?$($trelloConfig.String)"
			"$baseUrl/boards/$BoardId/lists?$($trelloConfig.String)"
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
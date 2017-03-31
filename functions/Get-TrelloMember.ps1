function Get-TrelloMember
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[Alias('Id')]
		[string]$BoardId
	)
	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try
		{
			Invoke-RestMethod -Uri ("$baseUrl/boards/{0}/members?{1}" -f $BoardId, $trelloConfig.String)
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
function Get-TrelloBoardList
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[string]$id
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
		$baseUrl = $Global:trelloConfig.BaseUrl 
		$apiString = $Global:trelloConfig.String
		$uri = "$baseUrl/boards/{0}?lists=open&$apiString"
	}
	process
	{
		try
		{			
			$lists = (Invoke-RestMethod ($uri -f $id)).lists
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
	end { 
		return $lists 
	}
}
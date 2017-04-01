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
		$uri = "$baseUrl/lists/{0}?$apiString"
	}
	process
	{
		try
		{			
			($uri -f $id)
			Invoke-RestMethod ($uri -f $id)
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
	<# 
		Problem: The id passed needs to be the list id to use the list api call. 

		I can either write to functions for this 1 that requires a boardID passed 
		in and 1 that gets a list by list id. 

		Or I can write one function that takes two params and calls a different api 
		method depending on what param is passed. 
		
	#> 
}
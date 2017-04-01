function Get-TrelloMember
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]		
		$InputObject
	)
	begin {
		$ErrorActionPreference = 'Stop'
		$baseUrl = $Global:trelloConfig.BaseUrl
		$apiString = $Global:trelloConfig.String
	}
	process {
		try
		{		
			$uri = "$baseUrl/members/{0}?$apiString"								
			foreach ($object in $InputObject) { 
				$uri -f $object.Id
			}
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
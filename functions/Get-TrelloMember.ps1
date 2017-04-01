function Get-TrelloMember
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]			
		[AllowNull()][Object]$idMembers
	)
	begin {
		$ErrorActionPreference = 'Stop'
		$baseUrl = $Global:trelloConfig.BaseUrl
		$apiString = $Global:trelloConfig.String
		$members = @() 	
	}
	process {
		try
		{		
			$uri = "$baseUrl/members/{0}?$apiString"								
			foreach ($id in $idMembers) { 
				$members += Invoke-RestMethod  ($uri -f $id)
			}
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	} 
	end { 
		return $members 
	}
}
function Enable-ChecklistItem
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[object]$Card,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[object]$Checklist,
		
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$ChecklistItem
	)
	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try
		{
			$params = @{
				'Uri' = "$baseUrl/cards/{0}/checklist/{1}/checkItem/{2}?state=true&{3}" -f $Card.Id, $Checklist.Id, $ChecklistItem.Id, $trelloConfig.String
				'Method' = 'Put'	
			}
			Invoke-RestMethod @params
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
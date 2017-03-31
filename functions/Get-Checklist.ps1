function Get-Checklist
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[object]$Card,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name
		
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
	}
	process
	{
		try
		{
			$checkLists = Invoke-RestMethod -Uri ("$baseUrl/cards/{0}/checklists?{1}" -f $Card.Id, $trelloConfig.String)
			if ($PSBoundParameters.ContainsKey('Name')) {
				$checkLists | where {$_.name -eq $Name}
			}
			else
			{
				$checkLists	
			}
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
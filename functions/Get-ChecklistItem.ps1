function Get-ChecklistItem
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[pscustomobject]$Checklist,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name
	)
	begin {
		$ErrorActionPreference = 'Stop'
	}
	process {
		try
		{
			if ($PSBoundParameters.ContainsKey('Name')) {
				$checklist.checkItems | where {$_.Name -eq $Name}
			}
			else
			{
				$checklist.checkItems
			}
			
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}

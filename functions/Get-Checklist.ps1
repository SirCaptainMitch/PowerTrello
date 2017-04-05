function Get-Checklist
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory, ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[String]$Id,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name, 

		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$idCard 
		
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
		$baseUrl = $Global:trelloConfig.BaseUrl
		$string = $Global:trelloConfig.String
		$uri = "$baseUrl/cards/{0}/checklists?$string"
		$checkLists = @()

		function Get-Checklist { 
			Param( 
				[Parameter(Mandatory)]
				[String]$RequestUrl 
			)

			$results = @()

			$checkListsCall = Invoke-RestMethod -Uri $RequestUrl

			foreach ($checkList in $checkListsCall) { 
				$createdDate = Convert-IdToDate $checkList.Id 
				Add-Member -InputObject $checkList -NotePropertyName CreatedDate -NotePropertyValue $createdDate  
				$results += $checkList
			}
			
			return $results 
		}
	}
	process
	{
		try
		{
			$request = $uri -f $id 
			$checkLists += Invoke-RestMethod -Uri 
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
	end { 
		return $checkLists 
	}
}
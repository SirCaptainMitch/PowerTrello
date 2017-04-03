function Get-TrelloBoard
{
	[CmdletBinding(DefaultParameterSetName = 'None')]
	param
	(
		[Parameter(ParameterSetName = 'ByName')]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter(ParameterSetName = 'ById')]
		[ValidateNotNullOrEmpty()]
		[string]$Id,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[switch]$IncludeClosedBoards
	)
	begin {
		$ErrorActionPreference = 'Stop'
		$boards = @()
	}
	process {
		try
		{
			$getParams = @{
				'key' = $trelloConfig.APIKey
				'token' = $trelloConfig.AccessToken
			}
			if (-not $IncludeClosedBoards.IsPresent)
			{
				$getParams.filter = 'open'
			}
			
			$baseUrl = $Global:trelloConfig.BaseUrl
			$keyValues = @()
			$getParams.GetEnumerator() | foreach {
				$keyValues += "$($_.Key)=$($_.Value)"
			}
			
			$paramString = $keyValues -join '&'
			
			switch ($PSCmdlet.ParameterSetName)
			{
				'ByName' {
					$uri = "$baseUrl/members/me/boards"
					$boards = Invoke-RestMethod -Uri ('{0}?{1}' -f $uri, $paramString)
					$boards | where { $_.name -eq $Name }
				}
				'ById' {
					$uri = "$baseUrl/boards/$Id"
					$boards = Invoke-RestMethod -Uri ('{0}?{1}' -f $uri, $paramString)
				}
				default
				{
					$uri = "$baseUrl/members/me/boards"
					$boards = Invoke-RestMethod -Uri ('{0}?{1}' -f $uri, $paramString)
				}
			}
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
	end { 
		return $boards 
	}
}
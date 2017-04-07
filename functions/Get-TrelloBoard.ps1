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
		[string]$Status = "open"
	)
	begin {
		$ErrorActionPreference = 'Stop'
		$baseUrl = $Global:trelloConfig.BaseUrl 
		$string  = $Global:trelloConfig.String 
		$boards = @()
	}
	process {
		try
		{
			switch ($PSCmdlet.ParameterSetName)
			{
				'ByName' {
					$uri = "$baseUrl/members/me/boards?$string"
					$boards = (Invoke-RestMethod -Uri $uri ) | Where-Object { $_.name -eq $Name }
					 
				}
				'ById' {
					$uri = "$baseUrl/boards/$Id/?$string"
					$boards = Invoke-RestMethod -Uri $uri
				}
				default
				{
					$uri = "$baseUrl/members/me/boards?$string"
					$boards = Invoke-RestMethod -Uri $uri 
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
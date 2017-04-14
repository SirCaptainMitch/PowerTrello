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

		if(!(Check-TrelloConfig)){ 
			Write-Warning "The configuration is missing, please set the Trello config again."
			continue
		}
	}
	process {
		try
		{
			switch ($PSCmdlet.ParameterSetName)
			{
				'ByName' {
					$uri = "$baseUrl/members/me/boards?$string"
					$boards = ( Invoke-RestMethod -Uri $uri )  | Where-Object { $_.name -eq $Name }
					$boards
					 
				}
				'ById' {
					$uri = "$baseUrl/boards/$Id/?$string"
					$boards = Invoke-RestMethod -Uri $uri
					$boards
				}
				default
				{
					$uri = "$baseUrl/members/me/boards?$string"
					$boards = Invoke-RestMethod -Uri $uri 
					$boards
				}
			}
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
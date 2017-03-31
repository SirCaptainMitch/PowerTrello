function Request-TrelloAccessToken
{
	[CmdletBinding()]
	[OutputType('System.String')]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ApiKey,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Scope = 'read,write',
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$ApplicationName = 'PowerTrello',
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$AuthTimeout = 30
		
	)
	
	$ErrorActionPreference = 'Stop'
	try
	{

		If (!$ApiKey) { $ApiKey = $global:trelloConfig.ApiKey}

		$httpParams = @{
			'key' = $apiKey
			'expiration' = 'never'
			'scope' = $Scope
			'response_type' = 'token'
			'name' = $ApplicationName
			'return_url' = 'https://trello.com'			
		}
		
		$keyValues = @()
		$baseUrl = 'https://trello.com/1/authorize/?'
		$httpParams.GetEnumerator() | sort-object Name | foreach{
			$keyValues += "$($_.Key)=$($_.Value)"
		}
		
		$keyValueString = $keyValues -join '&'
		$authUri = "$baseUrl$keyValueString"

		$IE = New-Object -ComObject InternetExplorer.Application
		$null = $IE.Navigate($authUri)
		$null = $IE.Visible = $true
		
		$timer = [System.Diagnostics.Stopwatch]::StartNew()
		while (($IE.LocationUrl -notmatch '^https://trello.com/token=') -and ($timer.Elapsed.TotalSeconds -lt $AuthTimeout))
		{
			Start-Sleep -Seconds 1
		}
		$timer.Stop()
		
		if ($timer.Elapsed.TotalSeconds -ge $AuthTimeout)
		{
			throw 'Timeout waiting for user authorization.'
		}
		
		[regex]::Match($IE.LocationURL, 'token=(.+)').Groups[1].Value
		
	}
	catch
	{
		Write-Error $_.Exception.Message
	}
	finally
	{
		$null = $IE.Quit()	
	}
}
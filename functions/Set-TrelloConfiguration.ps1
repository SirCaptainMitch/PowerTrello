function Set-TrelloConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]        
        [string]$ApiKey,
	
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AccessToken, 
        
        [ValidateNotNullOrEmpty()]
        [string]$BaseUrl = 'https://api.trello.com/1/', 
        
        [ValidateNotNullOrEmpty()]
        [string]$ProjectName = 'PowerTrello'
    )

    $global:trelloConfig = [pscustomobject]@{
        'APIKey' = $APIKey
        'AccessToken' = $AccessToken
        'String' = "key=$APIKey&token=$AccessToken"
        'ProjectName' = $ProjectName
        'BaseUrl' = $BaseUrl
    }    
}
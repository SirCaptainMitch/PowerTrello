function Set-TrelloConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]        
        [string]$ApiKey,
	
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$AccessToken, 
        
        [ValidateNotNullOrEmpty()]
        [string]$BaseUrl = 'https://api.trello.com/1', 
        
        [ValidateNotNullOrEmpty()]
        [string]$ProjectName = 'PowerTrello',
        
        [ValidateNotNullOrEmpty()]
        [string]$CustomFieldsPath = '.\config\Custom-Fields.json'
    )

    begin { 
        
        if ((Test-Path -Path $CustomFieldsPath)) { 
            $customFields = Get-Content $CustomFieldsPath -raw | ConvertFrom-JSON 
        }
    }

    process { 
        $global:trelloConfig = [pscustomobject]@{
            'APIKey' = $APIKey
            'AccessToken' = $AccessToken
            'String' = "key=$APIKey&token=$AccessToken"
            'ProjectName' = $ProjectName
            'BaseUrl' = $BaseUrl
            'CustomFields' = $customFields
        }    
    }    
}
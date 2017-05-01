function Set-TrelloCustomFieldsConfig {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [string]$CustomFieldsPath = '.\config\Custom-Fields.json'
    )
    
    begin {
         $global:trelloConfig.CustomFields = Get-Content $CustomFieldsPath -raw | ConvertFrom-JSON 
    }
    
    process {
    }
    
    end {
    }
}
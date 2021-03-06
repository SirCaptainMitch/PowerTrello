function Get-TrelloCardCustomFields {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[string]$id, 
        [switch]$UnknownFields 
    )
    
    begin {
        $ErrorActionPreference = 'Stop'
		$baseUrl = $Global:trelloConfig.BaseUrl 
		$apiString = $Global:trelloConfig.String
        $fields = $Global:trelloConfig.CustomFields.fields
		$uri = "$baseUrl/cards/{0}/pluginData?$apiString"
        $customfields = @();

        if (!(Check-TrelloConfig)) { 
            Write-Warning "TrelloConfig is missing, please set this up."
            continue
        }

        if ( !$fields ) { 
            Write-Warning "ConfigFields are not setup."            
        }
    }
    
    process {
        
        $cardUri = $uri -f $id
        $result = Invoke-RestMethod -Uri $cardUri
        try { 
            $data = $result.value.Replace('{"fields":{', '')
            $data = $data.Replace('}}', '')
            $data = $data.Replace('"', '')

            $properties = $data -split ',' | ConvertFrom-String -Delimiter ':' -PropertyNames FieldName, FieldValue

            foreach ( $prop in $properties ){
                $x = [PSCustomObject]@{ 
                                    'Field' = $prop.FieldName
                                    'Value' = $prop.FieldValue
                                 }

                foreach ($field in $fields ) {
                    if ($field.id -eq $prop.FieldName){
                        $x.Field = $field.name                    
                    }
                }

                $customfields += $x
            }

            return $customfields        
        }  catch { 
            
        } 
        
    }
}
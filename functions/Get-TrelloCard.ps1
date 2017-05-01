function Get-TrelloCard {
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [String]$id,
		
        [Parameter(ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,	
		
        [Parameter(ParameterSetName = 'Label')]
        [ValidateNotNullOrEmpty()]
        [string]$Label,
	
        [Parameter(ParameterSetName = 'Due')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Today','Tomorrow','In7Days','In14Days')]
        [string]$Due, 

        [Parameter()]
        [String]$Status = 'open', 

        [switch]$CustomFields
				
    )
    begin {
        $ErrorActionPreference = 'Stop'
        $baseUrl = $Global:trelloConfig.BaseUrl
        $string = $Global:trelloConfig.String
        $uri = "$baseUrl/cards/{0}?&$string"
        $searchUri = "$baseUrl/search?query=$name&$string"
        $cards = @()

    }
    process {

        if ($id){
            $request = $uri -f $id
            $return = Invoke-RestMethod -uri $request
        } elseif ($name) { 
            $request = $searchUri
            $return =  (Invoke-RestMethod -uri $request).cards
        }
        
        foreach ($card in $return ){ 
            $createdDate = Convert-IdToDate -ObjectId $card.Id
            
            if ( $CustomFields ) {                     
                $fields = $card | Get-TrelloCardCustomFields
                Add-Member -InputObject $card -NotePropertyName 'fields' -NotePropertyValue $fields                 
            }
            
            
            Add-Member -InputObject $card -NotePropertyName CreatedDate -NotePropertyValue $createdDate
            

            $cards += $card
        }


        return $cards
    }
}

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
        [String]$Status = 'open'
				
    )
    begin {
        $ErrorActionPreference = 'Stop'
        $baseUrl = $Global:trelloConfig.BaseUrl
        $string = $Global:trelloConfig.String
        $uri = "$baseUrl/boards/{0}/cards?filter=all&$string"
        $cards = @() 	

    }
    process {

        $request = $uri -f $id
        $return = Invoke-RestMethod -uri $request

        foreach ($card in $return ){ 
            $createdDate = Convert-IdToDate -ObjectId $card.Id
            Add-Member -InputObject $card -NotePropertyName CreatedDate -NotePropertyValue $createdDate 
            $cards += $card
        }
    }
}

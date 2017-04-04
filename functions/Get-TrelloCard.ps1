function Get-TrelloCard {
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
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

        # function Get-Cards { 
        #     [CmdletBinding()]
        #     Param 
        #     ( 
        #         [Parameter()]
        #         [String]$id, 
		# 		[string]$RequestUri
        #     )
			
        #     $results = @()
        #     $cardCall = Invoke-RestMethod -Uri $RequestUri

        #     # Get the created date of the card since this is pulled from the id. 
        #     foreach ( $c in $cardCall){ 
        #         
        #     }
		# 	return $results 
        # }
    }
    process {

            $request = $uri -f $id
            $return = Invoke-RestMethod -uri $request

            foreach ($card in $return ){ 
                $createdDate = Convert-IdToDate -ObjectId $card.Id
                Add-Member -InputObject $card -NotePropertyName CreatedDate -NotePropertyValue $createdDate 
                $cards += $card
            }
            
        # try {
		# 	# foreach ($board in $boards) {               
        #         # # have not tested all of these just yet. 
        #         # if ($PSBoundParameters.ContainsKey('Label')) {                    
        #         #      $cards += $boardCards| Where-Object { if (($_.labels) -and $_.labels.Name -contains $Label) { $true } }
        #         # }
        #         # elseif ($PSBoundParameters.ContainsKey('Due'))
        #         # {
        #         #     $cards = $boardCards
        #         # }
        #         # elseif ($PSBoundParameters.ContainsKey('Name'))
        #         # {
        #         #     $cards = $boardCards | Where-Object {$_.Name -eq $Name}
        #         # }
        #         # elseif ($PSBoundParameters.ContainsKey('Id'))
        #         # {
        #         #     $cards = $boardCards| Where-Object {$_.idShort -eq $Id}
        #         # }
        #         # else
        #         # {
        #         #     $cards = $boardCards
        #         # }
        #     }
        # }
        # catch {
        #     Write-Error $_.Exception.Message
        # }
    }
	end { 
		return $cards
	}
}

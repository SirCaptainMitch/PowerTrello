function Get-TrelloBoardCard {
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
        [String]$Status = 'open', 

        [Parameter(ParameterSetName= 'ShortId')]
        [String]$ShortId
				
    )
    begin {
        $ErrorActionPreference = 'Stop'
        $baseUrl = $Global:trelloConfig.BaseUrl
        $string = $Global:trelloConfig.String
        $uri = "$baseUrl/boards/{0}/cards?filter={1}&$string"
        $cards = @()
        $filters = @('all', 'closed', 'none', 'open','visible')
        
        if($filters -notcontains $status) 
        { 
            Write-Warning "The filter status: $Status does not exist..."
            continue 
        }

        function Get-Cards { 
            [CmdletBinding()]
            Param 
            ( 
                [Parameter()]
				[string]$RequestUri
            )
			
            $results = @()
            $cardCall = Invoke-RestMethod -Uri $RequestUri

            # Get the created date of the card since this is pulled from the id. 
            foreach ( $card in $cardCall){
                                 
                $createdDate = Convert-IdToDate -ObjectId $card.Id
                Add-Member -InputObject $card -NotePropertyName CreatedDate -NotePropertyValue $createdDate 
                $results += $card            
            }
			return $results
        }
    }
    process {        
        $request = $uri -f $id, $Status        
        $boardCards = Get-Cards -RequestUri $request 

        try {			               
            # # have not tested all of these just yet. 
            if ($PSBoundParameters.ContainsKey('Label')) {                    
                $cards += $boardCards| Where-Object { if (($_.labels) -and $_.labels.Name -contains $Label) { $true } }
            }
            elseif ($PSBoundParameters.ContainsKey('Due'))
            {
                $cards += $boardCards
            }
            elseif ($PSBoundParameters.ContainsKey('Name'))
            {
                $cards += $boardCards | Where-Object {$_.Name -eq $Name}
            }
            elseif ($PSBoundParameters.ContainsKey('ShortId'))
            {
                $cards += $boardCards| Where-Object {$_.idShort -eq $Id}
            }
            else
            {
                $cards += $boardCards    
            }            
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
	end { 
		return $cards
	}
}

function Get-TrelloCard {
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]$Boards,
		
        [Parameter(ParameterSetName = 'Name')]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
		
        [Parameter(ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [string]$Id,
		
        [Parameter(ParameterSetName = 'Label')]
        [ValidateNotNullOrEmpty()]
        [string]$Label,
	
        [Parameter(ParameterSetName = 'Due')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Today','Tomorrow','In7Days','In14Days')]
        [string]$Due
		
		
    )
    begin {
        $ErrorActionPreference = 'Stop'
        $baseUrl = $Global:trelloConfig.BaseUrl
        $cards = @() 	

        function Get-Cards { 
            [CmdletBinding()]
            Param 
            ( 
                [Parameter()]
                [Object]$Board, 
				[string]$RequestUri
            )
			
            $results = @()
            $cardCall = Invoke-RestMethod -Uri $RequestUri

            # Get the created date of the card since this is pulled from the id. 
            foreach ( $c in $cardCall){ 
                $createdDate = Convert-IdToDate -ObjectId $c.Id
                Add-Member -InputObject $c -NotePropertyName CreatedDate -NotePropertyValue $createdDate 
                $results += $c  
            }
			return $results 
        }
    }
    process {
        try {

			foreach ($board in $boards) { 
                $uri = "$baseUrl/boards/$($Board.Id)/cards?$($trelloConfig.String)"
                $boardCards = Get-Cards -Board $board -RequestUri $uri
               
                # have not tested all of these just yet. 
                if ($PSBoundParameters.ContainsKey('Label')) {                    
                     $cards += $boardCards| Where-Object { if (($_.labels) -and $_.labels.Name -contains $Label) { $true } }
                }
                elseif ($PSBoundParameters.ContainsKey('Due'))
                {
                    $cards = $boardCards
                }
                elseif ($PSBoundParameters.ContainsKey('Name'))
                {
                    $cards = $boardCards | Where-Object {$_.Name -eq $Name}
                }
                elseif ($PSBoundParameters.ContainsKey('Id'))
                {
                    $cards = $boardCards| Where-Object {$_.idShort -eq $Id}
                }
                else
                {
                    $cards = $boardCards
                }

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
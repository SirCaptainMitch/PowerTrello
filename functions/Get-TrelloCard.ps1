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
			
			return Invoke-RestMethod -Uri $requestUri
        }
    }
    process {
        try {			            

			# "$baseUrl/boards/$($Board.Id)/cards?$($trelloConfig.String)"

            # if ($PSBoundParameters.ContainsKey('Label')) {
            # 	$cards | where { if (($_.labels) -and $_.labels.Name -contains $Label) { $true } }
            # }
            # elseif ($PSBoundParameters.ContainsKey('Due'))
            # {
            # 	$cards
            # }
            # elseif ($PSBoundParameters.ContainsKey('Name'))
            # {
            # 	$cards | where {$_.Name -eq $Name}
            # }
            # elseif ($PSBoundParameters.ContainsKey('Id'))
            # {
            # 	$cards | where {$_.idShort -eq $Id}
            # }
            # else
            # {
            # 	$cards
            # }


			foreach ($board in $boards) { 
               $cards += Get-Cards -Board $board -RequestUri $uri
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
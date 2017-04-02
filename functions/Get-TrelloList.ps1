function Get-TrelloList {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("id")]
        [String]$idList
    )
    
    begin {
        $ErrorActionPreference = 'Stop'
        $baseUrl = $Global:trelloConfig.BaseUrl 
        $string = $Global:trelloConfig.String
        $uri = "$baseUrl/lists/{0}?$string"
        $results = @() 
    }
    
    process {
        try { 
            $list = Invoke-RestMethod ($uri -f $idList )
            Add-Member -InputObject $list -NotePropertyName CreatedDate -NotePropertyValue (Convert-IdToDate $list.id)
            $results += $list
        } catch { 
            Write-Error $_.Exception.Message
        }
       
    }
    
    end {
       return $results  
    }
}
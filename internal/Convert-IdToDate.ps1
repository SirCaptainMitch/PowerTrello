function Convert-IdToDate {
    [CmdletBinding()]
    param (
        [string]$ObjectId        
    )
    
    begin {
        $origin = New-Object -TypeName datetime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
        <# 
            Trello created dates come from the first 8 characters on the id of the item. 
            http://help.trello.com/article/759-getting-the-time-a-card-or-board-was-created
        #> 
        $dateCharacters = $ObjectId.Substring(0,8)
        $unixTime = [System.Convert]::ToInt64($dateCharacters, 16)
    }
    
    process {
        $createDateTime = $origin.AddSeconds($unixTime)
    }
    
    end {
        return $createDateTime
    }
}
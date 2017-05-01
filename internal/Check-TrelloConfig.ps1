function Check-TrelloConfig {
    [CmdletBinding()]
    param (        
    )
    
    process {
        if(!$Global:trelloConfig){ 
            return $false         
        } else { 
            return $true
        }
    }    
}
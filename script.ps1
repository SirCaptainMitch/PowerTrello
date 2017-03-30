import-module .\Trello.psm1 -force

$apiKey = 'd178dbf92a25c6808c1b9f2e925d2bb8'
$token = '0fc4fba0d6de687d195c1af1453a8b81dee7c9789a8a1700cdddf5021b3fab6d '
# $token = Request-TrelloAccessToken -ApiKey d178dbf92a25c6808c1b9f2e925d2bb8

# Set-TrelloConfiguration –ApiKey $apiKey –Token $token


$global:trelloConfig = [pscustomobject]@{
				'APIKey' = $APIKey;
				'AccessToken' = $token
				'String' = "key=$($APIKey)&token=$($Token)"	
			}

$baseUrl = 'https://api.trello.com/1'
$ProjectName = 'PowerTrello'

$getParams = @{
				'key' = $trelloConfig.APIKey
				'token' = $trelloConfig.AccessToken
			}
			if (-not $IncludeClosedBoards.IsPresent)
			{
				$getParams.filter = 'open'
			}
			
			$keyValues = @()
			$getParams.GetEnumerator() | foreach {
				$keyValues += "$($_.Key)=$($_.Value)"
			}
			
			$paramString = $keyValues -join '&'

$uri = "$baseUrl/members/me/boards?filter=open&key=$apiKey&token=ec9ccba3ce6108ed5b30917868da732c6440e9a12a04630a449a4e4755fa7df0"

$cards = (Invoke-RestMethod -Uri $uri) | get-trellocard 

$results = @()

foreach ($card in $cards) { 
    $id = $card.id
    $dateCharacters = $id.Substring(0,8)
    $unixTime = [System.Convert]::ToInt64($dateCharacters, 16)

    $origin = New-Object -Type DateTime -ArgumentList 1970, 1, 1, 0, 0, 0, 0
    $createDateTime = $origin.AddSeconds($unixTime)
    
    $list = Invoke-RestMethod -Uri "https://api.trello.com/1/lists/$($card.idList)?key=$($apiKey)&token=$($token)"
    $membersUri = "https://api.trello.com/1/members/{0}?key=$($apiKey)&token=$($token)"

    foreach ( $member in $card.idMembers) 
    { 
        $m = $membersUri.Replace('{0}', $member)        
        Invoke-RestMethod -uri $m 
    }    

    # if ($createDateTime.Year -eq 2016) { 
    #     add-member -InputObject $card -NotePropertyName CreatedDate -NotePropertyValue $createDateTime
    #     add-member -InputObject $card -NotePropertyName BoardName -NotePropertyValue(Get-TrelloBoard -Id $card.idboard).Name
    #     add-member -InputObject $card -NotePropertyName ListName -NotePropertyValue $list.Name 
    #     $results += $card 
    # }    
    
    # $card
}


# $results | Export-Csv .\trellocards.csv

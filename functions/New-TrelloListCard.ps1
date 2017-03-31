function New-TrelloListCard
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[Alias('Id')]
		[string]$ListId,
		
		[Parameter()]
		[string]$Name,

        [Parameter()]
		[string]$Description,

        [Parameter()]
		[string]$Position = 'bottom',

        [Parameter()]
		[string]$idMembers,

        [Parameter()]
		[string]$idLabels,

        [Parameter()]
		[string]$urlSource,

        [Parameter()]
		[string]$fileSource,

        [Parameter()]
		[string]$idCardSource,

        [Parameter()]
		[string]$keepFromSource
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
	}
	process
	{
		try
		{
            $NewCardHash = @{
                'idList'=$ListId
            }
            if(-not [string]::IsNullOrEmpty($Name))
            {
                $NewCardHash['name'] = $Name
            }

            if(-not [string]::IsNullOrEmpty($Description))
            {
                $NewCardHash['desc'] = $Description
            }

            if(-not [string]::IsNullOrEmpty($Position))
            {
                $NewCardHash['pos'] = $Position
            }

            if(-not [string]::IsNullOrEmpty($idMembers))
            {
                $NewCardHash['idMembers'] = $idMembers
            }

            if(-not [string]::IsNullOrEmpty($idLabels))
            {
                $NewCardHash['idLabels'] = $idLabels
            }

            if(-not [string]::IsNullOrEmpty($urlSource))
            {
                $NewCardHash['urlSource'] = $urlSource
            }

            if(-not [string]::IsNullOrEmpty($fileSource))
            {
                $NewCardHash['fileSource'] = $fileSource
            }

            if(-not [string]::IsNullOrEmpty($idCardSource))
            {
                $NewCardHash['idCardSource'] = $idCardSource
            }

            if(-not [string]::IsNullOrEmpty($keepFromSource))
            {
                $NewCardHash['keepFromSource'] = $keepFromSource
            }

            $RestParams = @{
                'uri' = "$baseUrl/cards?$($trelloConfig.String)"
                'Method' = 'Post'
                'Body' = $NewCardHash
            }

			Invoke-RestMethod @RestParams
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
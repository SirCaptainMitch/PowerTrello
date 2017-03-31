function New-TrelloBoardList
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[ValidateNotNullOrEmpty()]
		[Alias('Id')]
		[string]$BoardId,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,

        [Parameter()]
		[string]$idListSource,

        [Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$position = 'top'
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
	}
	process
	{
		try
		{
            $NewListHash = @{
                'name'=$Name
                'idBoard' = $BoardId
                'pos' = $position
            }
            if(-not [string]::IsNullOrEmpty($idListSource))
            {
                $NewListHash['idListSource'] = $idListSource
            }

            $RestParams = @{
                'uri' = "$baseUrl/lists?$($trelloConfig.String)"
                'Method' = 'Post'
                'Body' = $NewListHash
            }

			Invoke-RestMethod @RestParams
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
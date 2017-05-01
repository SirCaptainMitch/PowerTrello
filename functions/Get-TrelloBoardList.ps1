function Get-TrelloBoardList
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[string]$id, 

		[String]$name
	)
	begin
	{
		$ErrorActionPreference = 'Stop'
		$baseUrl = $Global:trelloConfig.BaseUrl 
		$apiString = $Global:trelloConfig.String
		$uri = "$baseUrl/boards/{0}?lists=open&$apiString"
	}
	process
	{
		try
		{
			$lists = (Invoke-RestMethod ($uri -f $id)).lists

			if ($Name)
			{
				$lists = $lists | Where-Object { $_.name -eq $name}
			}

			foreach ($list in $lists)
			{ 
				Add-Member -InputObject $list -NotePropertyName CreatedDate -NotePropertyValue (Convert-IdToDate $list.id)
			}

			$lists 
		}
		catch
		{
			Write-Error $_.Exception.Message
		}
	}
}
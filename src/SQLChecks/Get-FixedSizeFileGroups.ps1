﻿function Get-FixedSizeFileGroups {
    [cmdletbinding()]Param(
         [parameter(Mandatory=$true)][string]$ServerInstance
        ,$WhitelistFilegroups # optional array or comma-delim string
    )

    $WLFGNames=@()
    if($WhitelistFilegroups -ne $null){$WLFGNames+=$WhitelistFilegroups.Split(",")}

    $query=(gc $PSScriptRoot/../SQLScripts/auto-growth-zero.sql -Raw)

    (Invoke-Sqlcmd -ServerInstance $ServerInstance -Database master -Query $query) | where {
        $WLFGNames -notcontains $_.f_name
    } | Select db_name,f_name,type_desc,state_desc,size_mb,f_path | ft
}

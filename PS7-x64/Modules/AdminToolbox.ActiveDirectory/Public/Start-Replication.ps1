function Start-Replication {
    <#
    .SYNOPSIS
    Extracted from EvoTec Blog

    https://evotec.xyz/active-directory-instant-replication-between-sites-with-powershell/

    .DESCRIPTION
    Initiates a replication sync on all Domain sites

    .PARAMETER Domain
    Specify a domain to start a replication sync for

    .EXAMPLE
    Starts a sync on the current domain environment

    Start-Replication

    .EXAMPLE
    Starts a sync on the specified domain environment

    Start-Replication -Domain Domain2.net

    .LINK
    https://evotec.xyz/active-directory-instant-replication-between-sites-with-powershell/
    #>

    [CmdletBinding()]
    param(
        [string] $Domain = $Env:USERDNSDOMAIN
    )
    $DistinguishedName = (Get-ADDomain -Server $Domain).DistinguishedName
    (Get-ADDomainController -Filter * -Server $Domain).Name | ForEach-Object {
        Write-Host -Message "Sync-DomainController - Forcing synchronization $_" -ForegroundColor Yellow
        repadmin.exe /syncall $_ $DistinguishedName /e /A | Out-Null
    }
}
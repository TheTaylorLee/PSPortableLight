function Enable-Firewall {
    <#
    .DESCRIPTION
    Disables the local firewall

    .EXAMPLE
    Disable-Firewall

    .Link
    https://github.com/TheTaylorLee/AdminToolbox
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
    )

    #Check for Admin Privleges
    Get-Elevation

    Write-Host "Enabling Firewall" -ForegroundColor Green
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True
}
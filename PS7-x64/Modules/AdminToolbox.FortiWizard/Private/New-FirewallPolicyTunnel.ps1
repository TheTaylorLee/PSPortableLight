#Used By New-P2PTunnel
#Used By New-DialUPTunnelDynamic
#Used By New-DialUPTunnelStatic

Function New-FirewallPolicyTunnel {
    <#
    .Description
    Create Firewall Policies for the tunnel.
    #>

    $TunnelName = Read-Host "Provide the tunnel name that was provided when creating the phase 1 interface. This is case sensitive (TunnelName)"
    $SourceInterfaceName = Read-Host "Specify the Source or Lan Interface name (Source Interface Name)"
    $SourceAddress = Read-Host "Specify the Source Address Object/s in space delimited format or the Source Address Group. (Source)"
    $DestinationAddress = Read-Host "Specify the Destination Address Object/s in space delimited format or the Destination Address Group. (Destination)"
    $Service = Read-Host "Specify the Service Object/s in space delimited format or the Service Group. If all specify ALL in capital letters. (Service)"

    Write-Output "
config firewall policy
    edit 0
        set name ""vpn_local_$TunnelName""
        set srcintf ""$SourceInterfaceName""
        set dstintf ""$TunnelName""
        set srcaddr ""$SourceAddress""
        set dstaddr ""$DestinationAddress""
        set action accept
        set schedule always
        set service ""$Service""
        set utm-status enable
        set ssl-ssh-profile Block-Malicious
        set ips-sensor default
        set logtraffic all
    next
end

config firewall policy
    edit 0
        set name ""vpn_remote_$TunnelName""
        set srcintf ""$TunnelName""
        set dstintf ""$SourceInterfaceName""
        set srcaddr ""$DestinationAddress""
        set dstaddr ""$SourceAddress""
        set action accept
        set schedule always
        set service ""$Service""
        set utm-status enable
        set ssl-ssh-profile Block-Malicious
        set ips-sensor default
        set logtraffic all
    next
end
"
}
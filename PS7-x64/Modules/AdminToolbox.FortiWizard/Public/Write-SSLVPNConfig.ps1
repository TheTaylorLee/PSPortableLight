Function Write-SSLVPNConfig {

    <#
    .Description
    Creates a Fortigate Config Script for a simple SSL Client VPN implementation.

    .Parameter CommaSeperatedDNSSuffixes
    DNS Suffixes for Split DNS

    .Parameter DNofParentOU
    Distinguished Name of the Top Level OU for the authenticating Domain

    .Parameter DNSServerIP
    IPv4 address of the DNS server used by the SSLVPN clients

    .Parameter InternalLanSubnetMask
    Subnet mask of the LANIP to be accessed ex: 255.255.255.0

    .Parameter InternalLanIP
    IP Address thats matches the Host Minimum for the Subnet

    .Parameter LanInterfaceName
    Name of the LAN interface containing the to be accessed Subnet

    .Parameter LDAPServerFriendlyName
    Friendly Name for referencing the LDAP authentication server

    .Parameter ServiceAccountPassword
    Password of the Authenticating service account

    .Parameter ServiceAccountsAMAccountName
    sAMAccountName for the service account that will authenticate to the LDAP server. The Service account should have domain adming privleges and be denied logon locally

    .Parameter WanInterfaceName
    Name of the WAN interface where the incoming sslvpn Connections should originate.

    .Example
    $Params = @{
        CommaSeperatedDNSSuffixes    = "domain.com,domain2.com"
        DNofParentOU                 = "DC=domain,DC=COM"
        DNSServerIP                  = "192.168.0.1"
        InternalLanIP                = "192.168.0.0"
        InternalLanSubnetMask        = "255.255.255.0"
        LanInterfaceName             = "port2"
        LDAPSERVERFriendlyName       = "DomainLdap"
        ServiceAccountPassword       = "Password"
        ServiceAccountsAMAccountName = "fortigate"
        WanInterfaceName             = "port1"
    }

    Write-SSLVPNConfig @Params

    .Example
    This example generates and SSH session and invokes the output of this function against that sessions.

    New-SSHSession -computername 192.168.0.1

    $Params = @{
        CommaSeperatedDNSSuffixes    = "domain.com,domain2.com"
        DNofParentOU                 = "DC=domain,DC=COM"
        DNSServerIP                  = "192.168.0.1"
        InternalLanIP                = "192.168.0.0"
        InternalLanSubnetMask        = "255.255.255.0"
        LanInterfaceName             = "port2"
        LDAPSERVERFriendlyName       = "DomainLdap"
        ServiceAccountPassword       = "Password"
        ServiceAccountsAMAccountName = "fortigate"
        WanInterfaceName             = "port1"
    }
    $command = Write-SSLVPNConfig @Params

    $result = Invoke-SSHCommand -Command $command -SessionId 0
    $result.output

    .Example
    This example generates multiple SSH sessions and invokes the output of this function against all active sessions.

    New-SSHSession -computername 192.168.0.1
    New-SSHSession -computername 192.168.1.1

    $Params = @{
        CommaSeperatedDNSSuffixes    = "domain.com,domain2.com"
        DNofParentOU                 = "DC=domain,DC=COM"
        DNSServerIP                  = "192.168.0.1"
        InternalLanIP                = "192.168.0.0"
        InternalLanSubnetMask        = "255.255.255.0"
        LanInterfaceName             = "port2"
        LDAPSERVERFriendlyName       = "DomainLdap"
        ServiceAccountPassword       = "Password"
        ServiceAccountsAMAccountName = "fortigate"
        WanInterfaceName             = "port1"
    }
    $command = Write-SSLVPNConfig @Params

    $sessions = Get-SSHSession
    foreach ($session in $sessions) {
        Write-Output "Invoking Command against $session.host"
        $result = Invoke-SSHCommand -Command $command -SessionId $session.sessionID
        $result.output
    }

    .Link
    https://github.com/TheTaylorLee/FortiWizard/tree/main/docs
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]$CommaSeperatedDNSSuffixes,
        [Parameter(Mandatory = $true)]$DNofParentOU,
        [Parameter(Mandatory = $true)][ValidatePattern('^[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}$')]$DNSServerIP,
        [Parameter(Mandatory = $true)][ValidateScript( {
                if ($_ -match '^[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}$') {
                    $true
                }
                else {
                    throw "$_ is an invalid pattern. You must provide a subnet mask and not a prefix."
                }
            })]$InternalLanSubnetMask,
        [Parameter(Mandatory = $true)][ValidatePattern('^[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}$')]$InternalLanIP,
        [Parameter(Mandatory = $true)]$LanInterfaceName,
        [Parameter(Mandatory = $true)]$LDAPServerFriendlyName,
        [Parameter(Mandatory = $true)]$ServiceAccountPassword,
        [Parameter(Mandatory = $true)]$ServiceAccountsAMAccountName,
        [Parameter(Mandatory = $true)]$WanInterfaceName
    )


    Write-Output "
#initial setup for enabling the Forticlient VPN Config

config user ldap
    edit ""$LDAPSERVERFriendlyName""
        set server $DNSServerIP
        set cnid sAMAccountName
        set dn ""$DNofParentOU""
        set type regular
        set username ""$ServiceAccountsAMAccountName""
        set password $ServiceAccountPassword
    next
end

config user group
    edit SSLVPNUsers
        set member ""$LDAPSERVERFriendlyName""
    next
end

config firewall address
    edit SSLVPN_TUNNEL_ADDR1
        set type iprange
        set associated-interface ssl.root
        set start-ip 10.212.134.1
        set end-ip 10.212.134.254
    next
end

config firewall address
    edit SSLVPN_InternalLan
        set visibility disable
        set subnet $InternalLanIP $InternalLanSubnetMask
    next
end

config vpn ssl web portal
    delete full-access
    delete web-access
    edit tunnel-access
        set tunnel-mode enable
        set ip-pools SSLVPN_TUNNEL_ADDR1
        set ipv6-tunnel-mode disable
        config split-dns
        edit 1
            set domains ""$CommaSeperatedDNSSuffixes""
            set dns-server1 $DNSServerIP
        next
        end
    next
    edit no-access
        set forticlient-download disable
    next
end

config vpn ssl settings
    set ssl-min-proto-ver tls1-0
    set idle-timeout 43200
    set auth-timeout 43200
    set tunnel-ip-pools SSLVPN_TUNNEL_ADDR1
    set dns-server1 $DNSServerIP
    set source-interface ""$WanInterfaceName""
    set source-address all
    set source-address6 all
    set default-portal no-access
    set port 10443
    config authentication-rule
        edit 1
            set groups SSLVPNUsers
            set portal tunnel-access
        next
    end
end

config firewall policy
    edit 0
        set name SSLVPN
        set srcintf ssl.root
        set dstintf ""$LanInterfaceName""
        set srcaddr all
        set dstaddr SSLVPN_InternalLan
        set action accept
        set schedule always
        set service ALL
        set utm-status enable
        set ssl-ssh-profile no-inspection
        set ips-sensor default
        set nat enable
        set groups SSLVPNUsers
    next
end"
}
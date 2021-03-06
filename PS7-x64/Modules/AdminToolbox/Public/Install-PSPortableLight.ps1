Function Install-PSPortableLight {

    <#
    .DESCRIPTION
    A smaller version of PSPortable that contains less packaged modules. Downloads and Deploys a portable PowerShell 7 package, an included custom profile, and multiple useful modules. Used by the developer of the Admintoolbox modules as a repeatable Powershell environment with little effort.

    .EXAMPLE
    Downloads the PSPortableLight package, unzips it to programdata, and launces it.

    Install-PSPortableLight

    .Link
    https://github.com/TheTaylorLee/AdminToolbox
    #>

    [CmdletBinding()]
    [Alias("PSPortableLight", "PSPL")]
    param (
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    (Invoke-WebRequest https://raw.githubusercontent.com/TheTaylorLee/PSPortableLight/main/Deploy-PSPortableLight.ps1 -UseBasicParsing).content | Invoke-Expression

}
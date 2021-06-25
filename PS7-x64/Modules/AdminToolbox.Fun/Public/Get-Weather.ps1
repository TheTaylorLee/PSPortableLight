function Get-Weather {
    <#
    .Description
    Shows weather for a location or the moon phase

    .Parameter Location
    Specify a location to get weather for

    .Notes
    For help modifying the function

    http://wttr.in/:help

    https://winaero.com/blog/get-weather-forecast-powershell/

    .Example
    Multiple Location Options Available

    Get-Weather -Location houston+texas

    paris                 # city name
    Eiffel+tower          # any location
    muc                   # airport code (3 letters)
    94107                 # area codes
    moon                  # Moon phase (add ,+US or ,+France for these cities)
    moon@2016-10-25       # Moon phase for the date (@2016-10-25)

    .Link
    Connect-SSH
    Enable-PSRemoting
    Enable-Remoting
    #>

    [Cmdletbinding()]
    Param(
        [Parameter(Mandatory = $true)]$Location
    )

    (Invoke-WebRequest http://wttr.in/"$Location"?QF -UserAgent "curl" -UseBasicParsing).Content
}
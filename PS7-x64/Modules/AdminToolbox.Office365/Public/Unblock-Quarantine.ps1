Function Unblock-Quarantine {
    <#
    .DESCRIPTION
    This is an alternative to the function Release-QuarantineMessage. This function bypasses the 1000 item per page limit by creating an array of results for up to 1000 pages and 1 million results. That is the log limit applied by Microsoft. I recommend limiting results as much as possible for performance reasons. Use Get-QuarantineMessage to restrict results further.

    .EXAMPLE
    Specify the number of pages with 1000 results to return

    Get-Quarantine -pages 15

    .EXAMPLE
    Return the default of 1 page with up to 1000 results of results from which emails can be released from quarantine.

    Release-Quarantine

    .EXAMPLE
    Specify the pagesize to limit output to only x number of results that can then be used to choose emails to release.

    Release-Quarantine -pagesize 15

    .EXAMPLE
    Allow sender to prevent future messages from the sender being quarantined. Additional steps may be required to guarantee results. Microsoft provides documentation on Mailflow rules for whitelisting senders.

    Release-Quarantine -AllowSender

    .NOTES
    Requires the ExchangeOnline module be installed, imported, and Connected.

    .LINK
    Get-QuarantineMessage
    Get-Quarantine
    Release-QuarantineMessage
    Export-QuarantineMessage
    Export-Quarantine
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)][ValidateRange(1, 1000)][int]$pages = 1,
        [Parameter(Mandatory = $false)][ValidateRange(1, 1000)][int]$pagesize = 1000,
        [Parameter(Mandatory = $false)][switch]$AllowSender
    )

    $array = foreach ($number in 1..$pages) {
        Get-QuarantineMessage -page $number -Pagesize $pagesize | Select-Object *
    }

    $Release = $array | Out-GridView -PassThru -Title 'Select the email or Emails you wish to release'

    if ($AllowSender) {
        $Release | Release-QuarantineMessage -AllowSender -ReleaseToAll
    }
    else {
        $Release | Release-QuarantineMessage -ReleaseToAll
    }
}
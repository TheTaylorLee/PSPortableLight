function Get-TenantDiagrams {
    <#
    .DESCRIPTION
    This funcion expands on the AZViz module by PrateekSingh. That module can export Azure resourcegroups to create dependency diagrams. This function will loop through all resource groups to create a diagram for all in a tenant and export them into a logical folder structure.

    .EXAMPLE
    Get-TenantDiagrams -theme light -OutPutFilePath c:\basefolder

    .NOTES
    Tested and compatible with AZViz version 1.0.9 and PSGraph version 2.1.38.27. If not working in the future look for changes in those modules versions
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)][ValidateSet('light', 'dark', 'neon')]$theme,
        [Parameter(Mandatory = $true)][ValidateScript( { Test-Path -Path $_ -IsValid })][string] $OutputFilePath,
        [Parameter(Mandatory = $false)][ValidateSet(1, 2, 3)][int] $LabelVerbosity = 1,
        [Parameter(Mandatory = $false)][ValidateSet(1, 2, 3)][int] $CategoryDepth = 3,
        [Parameter(Mandatory = $false)][ValidateSet('png', 'svg')][string] $OutputFormat = 'png',
        [Parameter(Mandatory = $false)][ValidateSet('left-to-right', 'top-to-bottom')][string] $Direction = 'left-to-right'
    )

    $script:dateis = Get-Date -Format MM-dd-yyyy

    if ($OutputFormat -eq 'svg') {
        $script:extension = '.svg'
    }
    else {
        $script:extension = '.png'
    }


    $Subscriptions = Get-AzSubscription

    foreach ($sub in $Subscriptions) {
        Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext
        $script:name = $sub.name
        New-Item -Path $OutputFilePath\$dateis\$name -ItemType Directory | Out-Null
        $AZResourcegroups = Get-AzResourceGroup

        foreach ($RGName in $AZResourcegroups) {

            $RG = $RGName.resourcegroupname
            $filename = $RG + $extension

            $Params = @{
                ResourceGroup  = $RG
                OutputFilePath = "$OutputFilePath\$dateis\$name\$filename"
                Theme          = $Theme
                OutputFormat   = $OutputFormat
                CategoryDepth  = $CategoryDepth
                Direction      = $Direction
                LabelVerbosity = $LabelVerbosity
            }

            Export-AzViz @params

        }
    }
}
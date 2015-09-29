function Set-AppTheme {
    [cmdletbinding(SupportsShouldProcess,DefaultParametersetName="Light")]
    param (
        [Parameter(ParameterSetName='Light',Mandatory=$true)]
            [switch]$Light,
        [Parameter(ParameterSetName="Dark",Mandatory=$true)]
            [switch]$Dark
    )

    if ($PSCmdlet.ParameterSetName -eq 'Light') {
        $RegValue = 1
    } else {
        $RegValue = 0
    }

    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\' | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            $null = New-Item -Path $_ -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $_ -Name AppsUseLightTheme -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $_ -Name AppsUseLightTheme -PropertyType DWord -Value $RegValue
        } else {
            Set-ItemProperty -Path $_ -Name AppsUseLightTheme -Value $RegValue
        }
    }
}

function Get-AppTheme {
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize\' | ForEach-Object {
        $HashTable = @{
            Name = if ($_ -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $_
        }
        try {
            $HashTable.DarkTheme = -not [bool](Get-ItemPropertyValue -Path $_ -Name AppsUseLightTheme -ErrorAction Stop)
        } catch {
            $HashTable.DarkTheme = $false
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Add-PowerShellWinX {
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            $null = New-Item -Path $_ -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $_ -Name DontUSePowerShellOnWinX -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $_ -Name DontUSePowerShellOnWinX -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $_ -Name DontUSePowerShellOnWinX -Value 0
        }
    }
}

function Remove-PowerShellWinX {
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            $null = New-Item -Path $_ -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $_ -Name DontUSePowerShellOnWinX -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $_ -Name DontUSePowerShellOnWinX -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $_ -Name DontUSePowerShellOnWinX -Value 1
        }
    }
}

function Get-PowerShellWinX {
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        $HashTable = @{
            Name = if ($_ -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $_
        }
        try {
            $HashTable.PowerShellWinX = -not [bool](Get-ItemPropertyValue -Path $_ -Name DontUSePowerShellOnWinX -ErrorAction Stop)
        } catch {
            $HashTable.PowerShellWinX = $false
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Remove-OneDriveNavPane {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}',
    'HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' | ForEach-Object {
        if (Test-Path -Path $_) {
            Set-ItemProperty -Path $_ -Name System.IsPinnedToNameSpaceTree -Value 0
        }
    }
    Remove-PSDrive -Name HKCR
}

function Add-OneDriveNavPane {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}',
    'HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' | ForEach-Object {
        if (Test-Path -Path $_) {
            Set-ItemProperty -Path $_ -Name System.IsPinnedToNameSpaceTree -Value 1
        }
    }
    Remove-PSDrive -Name HKCR
}

function Get-OneDriveNavPane {
    $null = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
    'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}',
    'HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' | ForEach-Object {
        if (Test-Path -Path $_) {
            New-Object -TypeName PSCustomObject -Property @{
                Path = $_
                OneDriveNavPaneEnabled = [bool](Get-ItemPropertyValue -Path $_ -Name System.IsPinnedToNameSpaceTree)
            }
        }
    }
    Remove-PSDrive -Name HKCR
}

function Enable-SnapFill {
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            $null = New-Item -Path $_ -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $_ -Name SnapFill -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $_ -Name SnapFill -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $_ -Name SnapFill -Value 1
        }
    }
}

function Disable-SnapFill {
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            $null = New-Item -Path $_ -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $_ -Name SnapFill -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $_ -Name SnapFill -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $_ -Name SnapFill -Value 0
        }
    }
}

function Get-SnapFill {
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        $HashTable = @{
            Name = if ($_ -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $_
        }
        try {
            $HashTable.SnapFillEnabled = [bool](Get-ItemPropertyValue -Path $_ -Name SnapFill -ErrorAction Stop)
        } catch {
            $HashTable.SnapFillEnabled = $false
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-SnapAssist {
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            $null = New-Item -Path $_ -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $_ -Name SnapAssist -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $_ -Name SnapAssist -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $_ -Name SnapAssist -Value 1
        }
    }
}

function Disable-SnapAssist {
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        if (-not (Test-Path -Path $_)) {
            $null = New-Item -Path $_ -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $_ -Name SnapAssist -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path $_ -Name SnapAssist -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $_ -Name SnapAssist -Value 0
        }
    }
}

function Get-SnapAssist {
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' | ForEach-Object {
        $HashTable = @{
            Name = if ($_ -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $_
        }
        try {
            $HashTable.SnapAssistEnabled = [bool](Get-ItemPropertyValue -Path $_ -Name SnapAssist -ErrorAction Stop)
        } catch {
            $HashTable.SnapAssistEnabled = $false
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-ShowFileExtension {
<#
.SYNOPSIS   
This function controls if the file extensions are either shown or hidden in Windows Explorer

.NOTES
Name:        Enable-ShowFileExtension
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name HideFileExt -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name HideFileExt -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name HideFileExt -Value 0
        }
    }
}

function Disable-ShowFileExtension {
<#
.SYNOPSIS   
This function controls if the file extensions are either shown or hidden in Windows Explorer

.NOTES
Name:        Disable-ShowFileExtension
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name HideFileExt -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name HideFileExt -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name HideFileExt -Value 1
        }
    }
}

function Get-ShowFileExtension {
<#
.SYNOPSIS   
This function controls if the file extensions are either shown or hidden in Windows Explorer

.NOTES
Name:        Get-ShowFileExtension
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.HideFileExt = if ((Get-ItemPropertyValue -Path $RegPath -Name HideFileExt -ErrorAction Stop) -eq 0) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.HideFileExt = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-ShowHiddenFiles {
<#
.SYNOPSIS   
This function controls if hidden files and folders are shown in Windows Explorer

.NOTES
Name:        Enable-ShowHiddenFiles
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name Hidden -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name Hidden -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name Hidden -Value 1
        }
    }
}

function Disable-ShowHiddenFiles {
<#
.SYNOPSIS   
This function controls if hidden files and folders are shown in Windows Explorer

.NOTES
Name:        Disable-ShowHiddenFiles
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name Hidden -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name Hidden -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name Hidden -Value 0
        }
    }
}

function Get-ShowHiddenFiles {
<#
.SYNOPSIS   
This function controls if hidden files and folders are shown in Windows Explorer

.NOTES
Name:        Get-ShowHiddenFiles
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.Hidden = if ((Get-ItemPropertyValue -Path $RegPath -Name Hidden -ErrorAction Stop) -eq 1) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.Hidden = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-ShowSuperHiddenFiles {
<#
.SYNOPSIS   
This function controls if super hidden files and folders are shown in Windows Explorer

.NOTES
Name:        Enable-ShowSuperHiddenFiles
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name ShowSuperHidden -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name ShowSuperHidden -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name ShowSuperHidden -Value 1
        }
    }
}

function Disable-ShowSuperHiddenFiles {
<#
.SYNOPSIS   
This function controls if super hidden files and folders are shown in Windows Explorer

.NOTES
Name:        Disable-ShowSuperHiddenFiles
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name ShowSuperHidden -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name ShowSuperHidden -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name ShowSuperHidden -Value 0
        }
    }
}

function Get-ShowSuperHiddenFiles {
<#
.SYNOPSIS   
This function controls if super hidden files and folders are shown in Windows Explorer

.NOTES
Name:        Get-ShowSuperHiddenFiles
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.ShowSuperHidden = if ((Get-ItemPropertyValue -Path $RegPath -Name ShowSuperHidden -ErrorAction Stop) -eq 1) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.ShowSuperHidden = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-StartMenuBingSearch {
<#
.SYNOPSIS   
This function controls if Bing search results are shown when searching through the Start Menu

.NOTES
Name:        Enable-StartMenuBingSearch
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Search"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name BingSearchEnabled -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name BingSearchEnabled -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name BingSearchEnabled -Value 1
        }
    }
}

function Disable-StartMenuBingSearch {
<#
.SYNOPSIS   
This function controls if Bing search results are shown when searching through the Start Menu

.NOTES
Name:        Disable-StartMenuBingSearch
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Search"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name BingSearchEnabled -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name BingSearchEnabled -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name BingSearchEnabled -Value 0
        }
    }
}

function Get-StartMenuBingSearch {
<#
.SYNOPSIS   
This function controls if Bing search results are shown when searching through the Start Menu

.NOTES
Name:        Get-StartMenuBingSearch
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)Software\Microsoft\Windows\CurrentVersion\Search"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.BingSearchEnabled = if ((Get-ItemPropertyValue -Path $RegPath -Name BingSearchEnabled -ErrorAction Stop) -eq 1) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.BingSearchEnabled = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-ExplorerThisPC {
<#
.SYNOPSIS   
This function controls where Explorer starts when openened. The default in Windows 10 is to open QuickAccess the Enable-ExplorerThisPC will revert this to 'This PC' while Disable-ExplorerThisPC will set the Windows 10 default of Quick Access.

.NOTES
Name:        Enable-ExplorerThisPC
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name LaunchTo -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name LaunchTo -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name LaunchTo -Value 1
        }
    }
}

function Disable-ExplorerThisPC {
<#
.SYNOPSIS   
This function controls where Explorer starts when openened. The default in Windows 10 is to open QuickAccess the Enable-ExplorerThisPC will revert this to 'This PC' while Disable-ExplorerThisPC will set the Windows 10 default of Quick Access.

.NOTES
Name:        Disable-ExplorerThisPC
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name LaunchTo -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name LaunchTo -PropertyType DWord -Value 2
        } else {
            Set-ItemProperty -Path $RegPath -Name LaunchTo -Value 2
        }
    }
}

function Get-ExplorerThisPC {
<#
.SYNOPSIS   
This function controls where Explorer starts when openened. The default in Windows 10 is to open QuickAccess the Enable-ExplorerThisPC will revert this to 'This PC' while Disable-ExplorerThisPC will set the Windows 10 default of Quick Access.

.NOTES
Name:        Get-ExplorerThisPC
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.LaunchTo = if ((Get-ItemPropertyValue -Path $RegPath -Name LaunchTo -ErrorAction Stop) -eq 1) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.LaunchTo = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-Windows7VolumeMixer {
<#
.SYNOPSIS   
This function changes the appearance of the Volume Mixer Enable-Windows7VolumeMixer will set the Volume Mixer appearance to match that of Windows 7/8. Disable-Windows7VolumeMixer will revert to the Windows 10 default.

.NOTES
Name:        Enable-Windows7VolumeMixer
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name EnableMtcUvc -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name EnableMtcUvc -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name EnableMtcUvc -Value 0
        }
    }
}

function Disable-Windows7VolumeMixer {
<#
.SYNOPSIS   
This function changes the appearance of the Volume Mixer Enable-Windows7VolumeMixer will set the Volume Mixer appearance to match that of Windows 7/8. Disable-Windows7VolumeMixer will revert to the Windows 10 default.

.NOTES
Name:        Disable-Windows7VolumeMixer
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name EnableMtcUvc -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name EnableMtcUvc -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name EnableMtcUvc -Value 1
        }
    }
}

function Get-Windows7VolumeMixer {
<#
.SYNOPSIS   
This function changes the appearance of the Volume Mixer Enable-Windows7VolumeMixer will set the Volume Mixer appearance to match that of Windows 7/8. Disable-Windows7VolumeMixer will revert to the Windows 10 default.

.NOTES
Name:        Get-Windows7VolumeMixer
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.EnableMtcUvc = if ((Get-ItemPropertyValue -Path $RegPath -Name EnableMtcUvc -ErrorAction Stop) -eq 0) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.EnableMtcUvc = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-LockScreen {
<#
.SYNOPSIS   
This function either enables or disables the Windows Lockscreen

.NOTES
Name:        Enable-LockScreen
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Policies\Microsoft\Windows\Personalization"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name NoLockScreen -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name NoLockScreen -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name NoLockScreen -Value 0
        }
    }
}

function Disable-LockScreen {
<#
.SYNOPSIS   
This function either enables or disables the Windows Lockscreen

.NOTES
Name:        Disable-LockScreen
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Policies\Microsoft\Windows\Personalization"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name NoLockScreen -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name NoLockScreen -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name NoLockScreen -Value 1
        }
    }
}

function Get-LockScreen {
<#
.SYNOPSIS   
This function either enables or disables the Windows Lockscreen

.NOTES
Name:        Get-LockScreen
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Policies\Microsoft\Windows\Personalization"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.NoLockScreen = if ((Get-ItemPropertyValue -Path $RegPath -Name NoLockScreen -ErrorAction Stop) -eq 0) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.NoLockScreen = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-QuickAccessShowRecent {
<#
.SYNOPSIS   
This function changes the behavior of Recent Files in Quick Access

.NOTES
Name:        Enable-QuickAccessShowRecent
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name ShowRecent -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name ShowRecent -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name ShowRecent -Value 1
        }
    }
}

function Disable-QuickAccessShowRecent {
<#
.SYNOPSIS   
This function changes the behavior of Recent Files in Quick Access

.NOTES
Name:        Disable-QuickAccessShowRecent
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name ShowRecent -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name ShowRecent -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name ShowRecent -Value 0
        }
    }
}

function Get-QuickAccessShowRecent {
<#
.SYNOPSIS   
This function changes the behavior of Recent Files in Quick Access

.NOTES
Name:        Get-QuickAccessShowRecent
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.ShowRecent = if ((Get-ItemPropertyValue -Path $RegPath -Name ShowRecent -ErrorAction Stop) -eq 1) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.ShowRecent = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}

function Enable-QuickAccessShowFrequent {
<#
.SYNOPSIS   
This function changes the behavior of Frequent Folders in Quick Access

.NOTES
Name:        Enable-QuickAccessShowFrequent
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name ShowFrequent -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name ShowFrequent -PropertyType DWord -Value 1
        } else {
            Set-ItemProperty -Path $RegPath -Name ShowFrequent -Value 1
        }
    }
}

function Disable-QuickAccessShowFrequent {
<#
.SYNOPSIS   
This function changes the behavior of Frequent Folders in Quick Access

.NOTES
Name:        Disable-QuickAccessShowFrequent
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com

.PARAMETER OnlySetHKCU
When this parameter is specified the changes are only applied to the Current User branch of the registry. Default behavior is to apply the changes to both the Current User and Local Machine branches of the registry
#>
param(
    [switch]$OnlySetHKCU
)
    $(if (-not $OnlySetHKCU) {"HKLM:\","HKCU:\"} else {"HKCU:\"}) | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
        if (-not (Test-Path -Path $RegPath)) {
            $null = New-Item -Path $RegPath -ItemType RegistryKey
        }
        if (-not (Get-ItemProperty -Path $RegPath -Name ShowFrequent -ErrorAction SilentlyContinue)) {
            $null = New-ItemProperty -Path $RegPath -Name ShowFrequent -PropertyType DWord -Value 0
        } else {
            Set-ItemProperty -Path $RegPath -Name ShowFrequent -Value 0
        }
    }
}

function Get-QuickAccessShowFrequent {
<#
.SYNOPSIS   
This function changes the behavior of Frequent Folders in Quick Access

.NOTES
Name:        Get-QuickAccessShowFrequent
Author:      Jaap Brasser
Version:     1.0.0
DateCreated: 2015-09-29
DateUpdated: 2015-09-29
Blog:        http://www.jaapbrasser.com
#>
    "HKLM:\","HKCU:\" | ForEach-Object {
        $RegPath = "$($_)SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
        $HashTable = @{
            Name = if ($RegPath -match 'HKLM:') {'LocalMachine'} else {'CurrentUser'}
            FullPath = $RegPath
        }
        try {
            $HashTable.ShowFrequent = if ((Get-ItemPropertyValue -Path $RegPath -Name ShowFrequent -ErrorAction Stop) -eq 1) {
                $true
            } else {
                $false
            }
        } catch {
            $HashTable.ShowFrequent = $null
        } finally {
            New-Object -TypeName PSCustomObject -Property $HashTable
        }
    }
}
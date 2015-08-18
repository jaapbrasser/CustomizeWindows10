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
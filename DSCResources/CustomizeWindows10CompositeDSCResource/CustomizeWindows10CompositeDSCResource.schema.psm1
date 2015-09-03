Configuration CustomizeWindows10CompositeDSCResource {
Param(

$EnableWin10ConnectedStandby = $true,
$EnablePowerShellOnWinX = $true,
$EnableSnapFill = $false,
$EnableSnapAssist = $false,
$ShowFileExtensions,
$ShowHiddenFiles = $false,
$ShowProtectedOSFiles = $false

)


switch ($EnableWin10ConnectedStandby) {

$true {$Win10DisableConnectedStandbyValue = '0'}
$false {$Win10DisableConnectedStandbyValue = '1'}

}

Registry Win10DisableConnectedStandby {
        Key = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power'
        ValueName = 'CsEnabled'
        ValueData = $Win10DisableConnectedStandbyValue
        ValueType = 'dword'

}

switch ($EnablePowerShellOnWinX) {

$true {$DontUSePowerShellOnWinXValue = '0'}
$false {$DontUSePowerShellOnWinXValue = '1'}

}

Registry DontUSePowerShellOnWinX {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'DontUSePowerShellOnWinX'
        ValueData = $DontUSePowerShellOnWinXValue
        ValueType = 'dword'

}

switch ($EnableSnapFill) {

$true {$EnableSnapFillValue = '0'}
$false {$EnableSnapFillValue = '1'}

}

Registry SnapFill {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'SnapFill'
        ValueData = $EnableSnapFillValue
        ValueType = 'dword'

}

switch ($EnableSnapAssist) {

$true {$EnableSnapAssistValue = '0'}
$false {$EnableSnapAssistValue = '1'}

}

Registry SnapAssist {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'SnapAssist'
        ValueData = $EnableSnapAssistValue
        ValueType = 'dword'

}


switch ($ShowFileExtensions) {

$true {$ShowFileExtensionsValue = '0'}
$false {$ShowFileExtensionsValue = '1'}

}

Registry ShowFileExtensions {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'HideFileExt'
        ValueData = $ShowFileExtensionsValue
        ValueType = 'dword'

}

switch ($ShowHiddenFiles) {

$true {$ShowHiddenFilesValue = '1'}
$false {$ShowHiddenFilesValue = '0'}

}

Registry ShowHiddenFiles {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'Hidden'
        ValueData = $ShowHiddenFilesValue
        ValueType = 'dword'

}

switch ($ShowProtectedOSFiles) {

$true {$ShowProtectedOSFilesValue = '1'}
$false {$ShowProtectedOSFilesValue = '0'}

}

Registry ShowProtectedOSFiles {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'ShowSuperHidden'
        ValueData = $ShowProtectedOSFilesValue
        ValueType = 'dword'

}

}
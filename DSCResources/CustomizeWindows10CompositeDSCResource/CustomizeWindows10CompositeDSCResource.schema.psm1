Configuration CustomizeWindows10CompositeDSCResource {
Param(

		$EnableWin10ConnectedStandby = $true,
		$EnablePowerShellOnWinX = $true,
		$EnableSnapFill = $false,
		$EnableSnapAssist = $false,
		$ShowFileExtensions,
		$ShowHiddenFiles = $false,
		$ShowProtectedOSFiles = $false,
		$ShowDesktopIcons = $true,
		$UserCredentials,
		[ValidateSet("Notify","Automatic")]
		[System.String]
		$WindowsUpdateMode = "AllowUserConfig",
		[ValidateSet("True","False")]
		[System.String]
        $EnableDriverInstallationFromWindowsUpdate = $true

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

Registry DontUsePowerShellOnWinX {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'DontUSePowerShellOnWinX'
        ValueData = $DontUSePowerShellOnWinXValue
        ValueType = 'dword'
        PSDSCRunAsCredential = $UserCredentials

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
        PSDSCRunAsCredential = $UserCredentials
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
        PSDSCRunAsCredential = $UserCredentials
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
        PSDSCRunAsCredential = $UserCredentials

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
        PSDSCRunAsCredential = $UserCredentials

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
        PSDSCRunAsCredential = $UserCredentials

}

switch ($ShowDesktopIcons) {

$true {$ShowDesktopIconsValue = '0'}
$false {$ShowDesktopIconsValue = '1'}

}

Registry ShowDesktopIcons {
        Key = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        ValueName = 'HideIcons'
        ValueData = $ShowDesktopIconsValue
        ValueType = 'dword'
        PSDSCRunAsCredential = $UserCredentials

}


Switch ($WindowsUpdateMode) {
        "Notify" {$WUOption = "1"}
        "Automatic" {$WUOption = "0"}
}


Registry WindowsUpdateMode {
        Key = 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
        ValueName = 'UxOption'
        ValueData = $WUOption
        ValueType = 'dword'

}


Switch ($EnableDriverInstallationFromWindowsUpdate) {
        $true {$WUDriverOption = '1'}
        $false {$WUDriverOption = '0'}
}


Registry WindowsUpdateDriverSetting01 {
        Key = 'HKLM:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\DriverSearching'
        ValueName = 'SearchOrderConfig'
        ValueData = $WUDriverOption
        ValueType = 'dword'

}

Registry WindowsUpdateDriverSetting02 {
        Key = 'HKLM:\SOFTWARE\MICROSOFT\Windows\CurrentVersion\Device Metadata'
        ValueName = 'PreventDeviceMetadataFromNetwork'
        ValueData = $WUDriverOption
        ValueType = 'dword'

}





}
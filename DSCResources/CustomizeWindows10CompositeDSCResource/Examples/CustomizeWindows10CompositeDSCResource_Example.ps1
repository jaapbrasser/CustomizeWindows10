Configuration ITPro {
    
    Import-DscResource -ModuleName CustomizeWindows10

    Node localhost {

	CustomizeWindows10CompositeDSCResource WindowsSettings {

		EnableWin10ConnectedStandby = $false
		EnablePowerShellOnWinX = $true
		EnableSnapFill = $true
		EnableSnapAssist = $true
		ShowFileExtensions = $true
		ShowHiddenFiles = $true
		ShowProtectedOSFiles = $true

	}

    }
}
# ========================================
# BK-Launcher V2 - App Definition
# AutoHotkey
# ========================================

return @{
    Id            = "autohotkey"
    Name          = "AutoHotkey"
    Type          = "binary"

    InstallMode   = "silent"
    UninstallMode = "interactive"

    Dependencies  = @()

    Detect = {
        Test-Path "C:\Program Files\AutoHotkey\AutoHotkey.exe"
    }

    Install = {
        $url  = "https://www.autohotkey.com/download/ahk-install.exe"
        $dest = "$env:TEMP\AutoHotkeySetup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process $dest -ArgumentList "/S" -Wait
    }

    Uninstall = {
        Start-Process "ms-settings:appsfeatures"
    }
}

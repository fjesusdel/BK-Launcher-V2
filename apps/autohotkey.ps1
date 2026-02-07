# ========================================
# BK-Launcher V2 - App Definition
# AutoHotkey
# ========================================

return @{
    Id            = "autohotkey"
    Name          = "AutoHotkey"
    Type          = "binary"

    Description = @"
AutoHotkey es una herramienta de automatizacion para Windows.
Permite crear scripts con atajos de teclado, macros y acciones automaticas.
Es utilizada para personalizar el sistema y mejorar la productividad.
"@

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

# ========================================
# BK-Launcher V2 - App Definition
# Rainmeter
# ========================================

return @{
    Id            = "rainmeter"
    Name          = "Rainmeter"
    Type          = "binary"

    Description = @"
Rainmeter es una plataforma de personalizacion del escritorio para Windows.
Permite mostrar informacion del sistema y crear interfaces visuales mediante skins.
Es la base necesaria para usar herramientas como Radial Launcher.
"@

    InstallMode   = "silent"
    UninstallMode = "interactive"

    Dependencies  = @()

    Detect = {
        Test-Path "C:\Program Files\Rainmeter\Rainmeter.exe"
    }

    Install = {
        $url  = "https://github.com/rainmeter/rainmeter/releases/latest/download/Rainmeter-4.5.20.exe"
        $dest = "$env:TEMP\RainmeterSetup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process $dest -ArgumentList "/S" -Wait
    }

    Uninstall = {
        Start-Process "ms-settings:appsfeatures"
    }
}

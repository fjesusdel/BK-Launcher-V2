# ========================================
# BK-Launcher V2 - App Definition
# Google Chrome
# ========================================

return @{
    Id            = "chrome"
    Name          = "Google Chrome"
    Type          = "binary"

    InstallMode   = "silent"
    UninstallMode = "interactive"

    Dependencies  = @()

    # ------------------------------------
    # Detectar si esta instalado
    # ------------------------------------
    Detect = {
        (Test-Path "C:\Program Files\Google\Chrome\Application\chrome.exe") -or
        (Test-Path "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
    }

    # ------------------------------------
    # Instalacion silenciosa (oficial)
    # ------------------------------------
    Install = {
        Write-Host " Descargando Google Chrome..." -ForegroundColor Cyan

        # Instalador oficial recomendado
        $url  = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
        $dest = "$env:TEMP\chrome-installer.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        Write-Host " Ejecutando instalacion silenciosa..." -ForegroundColor Cyan
        Start-Process -FilePath $dest -ArgumentList "/silent /install" -Wait
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {
        Write-Host " Lanzando desinstalador de Google Chrome..." -ForegroundColor Cyan

        $uninstallKey = Get-ItemProperty `
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" `
            -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "Google Chrome*" } |
            Select-Object -First 1

        if ($uninstallKey -and $uninstallKey.UninstallString) {
            Start-Process "cmd.exe" `
                -ArgumentList "/c `"$($uninstallKey.UninstallString)`"" `
                -Wait
        }
    }
}

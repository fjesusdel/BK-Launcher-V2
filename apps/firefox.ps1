# ========================================
# BK-Launcher V2 - App Definition
# Mozilla Firefox
# ========================================

return @{
    Id            = "firefox"
    Name          = "Mozilla Firefox"
    Type          = "binary"

    InstallMode   = "silent"
    UninstallMode = "interactive"

    Dependencies  = @()

    # ------------------------------------
    # Detectar si esta instalado
    # ------------------------------------
    Detect = {
        (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe") -or
        (Test-Path "C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
    }

    # ------------------------------------
    # Instalacion silenciosa (oficial)
    # NOTA: no probar ahora para no perder configuraciones
    # ------------------------------------
    Install = {
        Write-Host " Descargando Mozilla Firefox..." -ForegroundColor Cyan

        $url  = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=es-ES"
        $dest = "$env:TEMP\firefox-installer.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        Write-Host " Ejecutando instalacion silenciosa..." -ForegroundColor Cyan
        Start-Process -FilePath $dest -ArgumentList "-ms" -Wait
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {
        Write-Host " Lanzando desinstalador de Mozilla Firefox..." -ForegroundColor Cyan

        $uninstallKey = Get-ItemProperty `
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" `
            -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "Mozilla Firefox*" } |
            Select-Object -First 1

        if ($uninstallKey -and $uninstallKey.UninstallString) {
            Start-Process "cmd.exe" `
                -ArgumentList "/c `"$($uninstallKey.UninstallString)`"" `
                -Wait
        }
    }
}

# ========================================
# BK-Launcher V2 - App Definition
# Advanced IP Scanner
# ========================================

return @{
    Id   = "advanced-ip-scanner"
    Name = "Advanced IP Scanner"
    Type = "binary"

    InstallMode        = "silent"
    UninstallMode      = "interactive"
    VerifyAfterInstall = $true

    Dependencies = @()

    # ------------------------------------
    # DESCRIPCION
    # ------------------------------------
    Description = @"
Advanced IP Scanner es una herramienta para escanear redes locales.

Permite detectar rapidamente:
 - Equipos conectados a la red
 - Direcciones IP y MAC
 - Recursos compartidos
 - Equipos activos y apagados

Muy util para tareas de soporte tecnico
y administracion de redes.
"@

    # ------------------------------------
    # Detectar si esta instalado
    # ------------------------------------
    Detect = {
        Test-Path "C:\Program Files (x86)\Advanced IP Scanner\advanced_ip_scanner.exe"
    }

    # ------------------------------------
    # Instalacion (SILENCIOSA)
    # ------------------------------------
    Install = {

        Write-Host ""
        Write-Host " Descargando Advanced IP Scanner..." -ForegroundColor Cyan

        $url  = "https://github.com/fjesusdel/BK-Launcher-V2/releases/download/advanced-ip-scanner-2.5.4594.1/Advanced_IP_Scanner_2.5.4594.1.exe"
        $dest = "$env:TEMP\Advanced_IP_Scanner_Setup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        Write-Host " Instalando Advanced IP Scanner..." -ForegroundColor Cyan

        Start-Process $dest -ArgumentList "/S" -Wait

        Write-Host " Advanced IP Scanner instalado correctamente." -ForegroundColor Green
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {

        Write-Host ""
        Write-Host " Advanced IP Scanner debe desinstalarse desde Windows." -ForegroundColor Yellow
        Write-Host ""

        Start-Process "ms-settings:appsfeatures"
    }
}

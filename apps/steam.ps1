# ========================================
# BK-Launcher V2 - App Definition
# Steam
# ========================================

return @{
    Id            = "steam"
    Name          = "Steam"
    Type          = "binary"

    InstallMode   = "interactive"
    UninstallMode = "interactive"

    Dependencies  = @()

    # ------------------------------------
    # Detectar si esta instalado
    # Steam suele instalarse en Program Files (x86)
    # ------------------------------------
    Detect = {
        (Test-Path "C:\Program Files (x86)\Steam\Steam.exe") -or
        (Test-Path "C:\Program Files\Steam\Steam.exe")
    }

    # ------------------------------------
    # Instalacion (NO silenciosa)
    # ------------------------------------
    Install = {
        Write-Host ""
        Write-Host " Steam no se instala de forma silenciosa." -ForegroundColor Yellow
        Write-Host " Se abrira el instalador oficial." -ForegroundColor Yellow
        Write-Host " Sigue los pasos del asistente." -ForegroundColor Yellow
        Write-Host ""

        $url  = "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe"
        $dest = "$env:TEMP\SteamSetup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process $dest
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {
        Write-Host ""
        Write-Host " Steam debe desinstalarse manualmente." -ForegroundColor Yellow
        Write-Host " Se abrira el panel de aplicaciones de Windows." -ForegroundColor Yellow
        Write-Host ""

        Start-Process "ms-settings:appsfeatures"
    }
}

# ========================================
# BK-Launcher V2 - App Definition
# Discord
# ========================================

return @{
    Id            = "discord"
    Name          = "Discord"
    Type          = "binary"

    InstallMode   = "interactive"
    UninstallMode = "interactive"

    Dependencies  = @()

    # ------------------------------------
    # Detectar si esta instalado
    # Discord se instala por usuario
    # ------------------------------------
    Detect = {
        Test-Path "$env:LOCALAPPDATA\Discord\Update.exe"
    }

    # ------------------------------------
    # Instalacion (NO silenciosa)
    # ------------------------------------
    Install = {
        Write-Host ""
        Write-Host " Discord no se instala de forma silenciosa." -ForegroundColor Yellow
        Write-Host " Se abrira el instalador oficial." -ForegroundColor Yellow
        Write-Host " Sigue los pasos del asistente." -ForegroundColor Yellow
        Write-Host ""

        $url  = "https://discord.com/api/download?platform=win"
        $dest = "$env:TEMP\DiscordSetup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process $dest
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {
        Write-Host ""
        Write-Host " Discord debe desinstalarse manualmente." -ForegroundColor Yellow
        Write-Host " Se abrira el panel de aplicaciones de Windows." -ForegroundColor Yellow
        Write-Host ""

        Start-Process "ms-settings:appsfeatures"
    }
}

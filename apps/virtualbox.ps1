# ========================================
# BK-Launcher V2 - App Definition
# Oracle VirtualBox
# ========================================

return @{
    Id            = "virtualbox"
    Name          = "Oracle VirtualBox"
    Type          = "binary"

    InstallMode   = "interactive"
    UninstallMode = "interactive"

    Dependencies  = @()

    # ------------------------------------
    # Detectar si esta instalado
    # VirtualBox registra bien en Program Files
    # ------------------------------------
    Detect = {
        Test-Path "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
    }

    # ------------------------------------
    # Instalacion (NO silenciosa)
    # ------------------------------------
    Install = {
        Write-Host ""
        Write-Host " VirtualBox requiere instalacion interactiva." -ForegroundColor Yellow
        Write-Host " Se abrira el instalador oficial." -ForegroundColor Yellow
        Write-Host " Acepta los drivers cuando Windows lo solicite." -ForegroundColor Yellow
        Write-Host ""

        $url  = "https://download.virtualbox.org/virtualbox/7.0.14/VirtualBox-7.0.14-161095-Win.exe"
        $dest = "$env:TEMP\VirtualBoxSetup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process $dest
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {
        Write-Host ""
        Write-Host " VirtualBox debe desinstalarse manualmente." -ForegroundColor Yellow
        Write-Host " Se abrira el panel de aplicaciones de Windows." -ForegroundColor Yellow
        Write-Host ""

        Start-Process "ms-settings:appsfeatures"
    }
}

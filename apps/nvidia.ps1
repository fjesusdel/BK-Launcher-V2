# ========================================
# BK-Launcher V2 - App Definition
# Nvidia App
# ========================================

return @{
    Id   = "nvidia"
    Name = "Nvidia App"
    Type = "binary"

    InstallMode   = "interactive"
    UninstallMode = "interactive"

    Dependencies = @()

    # ------------------------------------
    # Detectar si Nvidia App esta instalada
    # (Registro, metodo fiable)
    # ------------------------------------
    Detect = {

        $paths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
        )

        foreach ($path in $paths) {
            $found = Get-ItemProperty $path -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.DisplayName -like "*NVIDIA App*"
                }

            if ($found) {
                return $true
            }
        }

        return $false
    }

    # ------------------------------------
    # Instalacion interactiva
    # ------------------------------------
    Install = {

        Write-Host ""
        Write-Host " Nvidia App se instalara mediante el instalador oficial." -ForegroundColor Yellow
        Write-Host " Sigue los pasos del asistente." -ForegroundColor Yellow
        Write-Host ""

        $url  = "https://us.download.nvidia.com/nvapp/client/installer/NVIDIA_app_v10.0.0.535.exe"
        $dest = "$env:TEMP\NVIDIA_App_Installer.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        # Lanzar instalador SIN esperar
        Start-Process $dest
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {

        Write-Host ""
        Write-Host " Nvidia App debe desinstalarse manualmente." -ForegroundColor Yellow
        Write-Host " Se abrira el panel de aplicaciones de Windows." -ForegroundColor Yellow
        Write-Host ""

        Start-Process "ms-settings:appsfeatures"
    }
}

# ========================================
# BK-Launcher V2 - App Definition
# WinRAR
# ========================================

return @{
    Id           = "winrar"
    Name         = "WinRAR"
    Type         = "binary"
    InstallMode  = "silent"
    Dependencies = @()

    # ------------------------------------
    # Detection
    # ------------------------------------
    Detect = {
        Test-Path "C:\Program Files\WinRAR\WinRAR.exe"
    }

    # ------------------------------------
    # Installation (placeholder)
    # ------------------------------------
    Install = {
        # Installation logic will be added later
        Write-Host "Instalacion de WinRAR (pendiente)"
    }

    # ------------------------------------
    # Uninstallation (placeholder)
    # ------------------------------------
    Uninstall = {
        # Uninstallation logic will be added later
        Write-Host "Desinstalacion de WinRAR (pendiente)"
    }
}

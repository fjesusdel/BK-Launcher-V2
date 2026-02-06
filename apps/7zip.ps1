# ========================================
# BK-Launcher V2 - App Definition
# 7-Zip
# ========================================

return @{
    Id            = "7zip"
    Name          = "7-Zip"
    Type          = "binary"

    InstallMode   = "silent"
    UninstallMode = "interactive"

    Dependencies  = @()

    # ------------------------------------
    # Detectar si esta instalado
    # ------------------------------------
    Detect = {
        Test-Path "C:\Program Files\7-Zip\7z.exe"
    }

    # ------------------------------------
    # Instalacion silenciosa
    # ------------------------------------
    Install = {
        Write-Host " Descargando 7-Zip..." -ForegroundColor Cyan

        $url  = "https://www.7-zip.org/a/7z2301-x64.exe"
        $dest = "$env:TEMP\7zip-installer.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        Write-Host " Ejecutando instalacion silenciosa..." -ForegroundColor Cyan
        Start-Process -FilePath $dest -ArgumentList "/S" -Wait
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {
        Write-Host " Lanzando desinstalador de 7-Zip..." -ForegroundColor Cyan

        $uninstallKey = Get-ItemProperty `
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" `
            -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "7-Zip*" } |
            Select-Object -First 1

        if ($uninstallKey -and $uninstallKey.UninstallString) {
            Start-Process "cmd.exe" `
                -ArgumentList "/c `"$($uninstallKey.UninstallString)`"" `
                -Wait
        }
    }
}

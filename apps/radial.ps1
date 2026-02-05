# ========================================
# BK-Launcher V2 - App Definition
# Radial Menu (Rainmeter Skin)
# ========================================

return @{
    Id            = "radial"
    Name          = "Radial Menu"
    Type          = "skin"

    InstallMode   = "interactive"
    UninstallMode = "manual"

    Dependencies  = @("rainmeter")

    Detect = {
        Test-Path "$env:USERPROFILE\Documents\Rainmeter\Skins\Radial-BK"
    }

    Install = {
        Write-Host ""
        Write-Host "Instalando Radial Menu (Rainmeter skin)..." -ForegroundColor Cyan
        Write-Host "Se abrira el instalador de Rainmeter." -ForegroundColor Yellow
        Write-Host ""

        $url  = "https://TU_URL_DE_DESCARGA/Radial-BK_2.0.rmskin"
        $dest = "$env:TEMP\Radial-BK_2.0.rmskin"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        # Abrir el instalador de Rainmeter (esto es CLAVE)
        Start-Process -FilePath $dest

        Write-Host ""
        Write-Host "Completa la instalacion en Rainmeter." -ForegroundColor Green
        Read-Host "Pulsa ENTER cuando hayas terminado"
    }

    Uninstall = {
        Write-Host ""
        Write-Host "La skin Radial debe desinstalarse manualmente desde Rainmeter." -ForegroundColor Yellow
        Write-Host "Se abrira la carpeta de skins." -ForegroundColor Yellow
        Start-Sleep 2
        Start-Process "explorer.exe" "$env:USERPROFILE\Documents\Rainmeter\Skins"
    }
}

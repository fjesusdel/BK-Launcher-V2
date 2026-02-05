# ========================================
# BK-Launcher V2 - App Definition
# Radial Launcher (Rainmeter Skin)
# ========================================

return @{
    Id                  = "radial"
    Name                = "Radial Launcher"
    Type                = "skin"

    InstallMode         = "interactive"
    UninstallMode       = "manual"
    VerifyAfterInstall  = $false

    Dependencies        = @("rainmeter")

    Detect = {
        Test-Path "$env:USERPROFILE\Documents\Rainmeter\Skins\RadialLauncher\RadialLauncher.ini"
    }

    Install = {
        Write-Host ""
        Write-Host "Instalando Radial Launcher (Rainmeter skin)..." -ForegroundColor Cyan
        Write-Host "Se abrira el instalador de Rainmeter." -ForegroundColor Yellow
        Write-Host ""

        $url  = "https://github.com/fjesusdel/BK-Launcher-V2/releases/download/radial-v2.0/Radial-BK_2.0.rmskin"
        $dest = "$env:TEMP\Radial-BK_2.0.rmskin"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        # Instalar la skin (.rmskin)
        Start-Process -FilePath $dest

        # Asegurar que Rainmeter esta ejecutandose
        Start-Sleep 3
        $rainmeterExe = "C:\Program Files\Rainmeter\Rainmeter.exe"
        if (Test-Path $rainmeterExe) {
            Start-Process $rainmeterExe
        }

        # Esperar a que Rainmeter termine de registrar la skin
        Start-Sleep 3

        # Cargar automaticamente la skin RadialLauncher
        Start-Process -FilePath $rainmeterExe `
            -ArgumentList "!ActivateConfig RadialLauncher RadialLauncher.ini"

        Write-Host ""
        Write-Host "Radial Launcher instalado y cargado correctamente." -ForegroundColor Green
    }

    Uninstall = {
        Write-Host ""
        Write-Host "La skin Radial Launcher debe desinstalarse manualmente desde Rainmeter." -ForegroundColor Yellow
        Write-Host "Se abrira la carpeta de skins." -ForegroundColor Yellow
        Start-Sleep 2
        Start-Process "explorer.exe" "$env:USERPROFILE\Documents\Rainmeter\Skins"
    }
}

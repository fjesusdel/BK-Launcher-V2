# ========================================
# BK-Launcher V2 - App Definition
# Radial Launcher (Rainmeter Skin)
# ========================================

return @{
    Id                  = "radial"
    Name                = "Radial Launcher"
    Type                = "skin"

    Description = @"
Skin de Rainmeter desarrollada para BK-Launcher.
Muestra un menu radial visual para lanzar aplicaciones y acciones rapidas.
Pensada para mejorar la productividad y el acceso rapido desde el escritorio.
"@

    InstallMode         = "interactive"
    UninstallMode       = "manual"
    VerifyAfterInstall  = $false

    Dependencies        = @("rainmeter")

    Detect = {
        Test-Path "$env:USERPROFILE\Documents\Rainmeter\Skins\RadialLauncher"
    }

    Install = {
        $url  = "https://github.com/fjesusdel/BK-Launcher-V2/releases/download/radial-v2.0/Radial-BK_2.0.rmskin"
        $dest = "$env:TEMP\Radial-BK_2.0.rmskin"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process $dest

        $rain = "C:\Program Files\Rainmeter\Rainmeter.exe"
        if (Test-Path $rain) {
            Start-Sleep 3
            Start-Process $rain -ArgumentList "!ActivateConfig RadialLauncher RadialLauncher.ini"
        }
    }

    Uninstall = {
        Write-Host ""
        Write-Host "Desinstalacion MANUAL de Radial Launcher" -ForegroundColor Yellow
        Write-Host "Se abrira la carpeta de la skin." -ForegroundColor Yellow
        Write-Host "Borra la carpeta si deseas eliminarla." -ForegroundColor Yellow
        Write-Host ""

        Start-Process "explorer.exe" "$env:USERPROFILE\Documents\Rainmeter\Skins"

        for ($i = 10; $i -ge 1; $i--) {
            Write-Host "Continuando en $i segundos..." -NoNewline
            Start-Sleep 1
            Write-Host "`r" -NoNewline
        }

        Write-Host ""
        Write-Host "Continuando con la siguiente aplicacion." -ForegroundColor Cyan
    }
}

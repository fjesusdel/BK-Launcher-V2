# ========================================
# BK-Launcher V2 - App Definition
# Rufus
# ========================================

return @{
    Id   = "rufus"
    Name = "Rufus V4.12"
    Type = "binary"

    Description = @"
Rufus es una herramienta para crear unidades USB booteables.
Permite preparar pendrives para instalar Windows, Linux u otros sistemas.
Es muy utilizada en entornos tecnicos y de mantenimiento.
"@

    InstallMode        = "silent"
    UninstallMode      = "none"
    VerifyAfterInstall = $true

    Dependencies = @()

    # ------------------------------------
    # Rutas
    # ------------------------------------
    InstallDir = "$env:ProgramFiles\Rufus"
    ExePath    = "$env:ProgramFiles\Rufus\rufus.exe"
    DesktopLnk = "$env:PUBLIC\Desktop\Rufus.lnk"

    # ------------------------------------
    # Detectar si esta instalado
    # ------------------------------------
    Detect = {
        Test-Path "$env:ProgramFiles\Rufus\rufus.exe"
    }

    # ------------------------------------
    # Instalacion
    # ------------------------------------
    Install = {

        Write-Host ""
        Write-Host " Descargando Rufus..." -ForegroundColor Cyan

        $dir = "$env:ProgramFiles\Rufus"
        $exe = "$dir\rufus.exe"
        $url = "https://github.com/pbatard/rufus/releases/download/v4.12/rufus-4.12.exe"

        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir | Out-Null
        }

        Invoke-WebRequest -Uri $url -OutFile $exe -UseBasicParsing

        Write-Host " Creando acceso directo en el escritorio..." -ForegroundColor Cyan

        $shell = New-Object -ComObject WScript.Shell
        $lnk   = $shell.CreateShortcut("$env:PUBLIC\Desktop\Rufus.lnk")
        $lnk.TargetPath = $exe
        $lnk.WorkingDirectory = $dir
        $lnk.IconLocation = $exe
        $lnk.Save()

        Write-Host ""
        Write-Host " Rufus instalado correctamente." -ForegroundColor Green
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {

        if (Test-Path "$env:PUBLIC\Desktop\Rufus.lnk") {
            Remove-Item "$env:PUBLIC\Desktop\Rufus.lnk" -Force
        }

        if (Test-Path "$env:ProgramFiles\Rufus") {
            Remove-Item "$env:ProgramFiles\Rufus" -Recurse -Force
        }

        Write-Host " Rufus eliminado." -ForegroundColor Yellow
    }
}

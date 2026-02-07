# ========================================
# BK-Launcher V2 - App Definition
# AnyDesk Portable
# ========================================

return @{
    Id   = "anydesk"
    Name = "AnyDesk Portable"
    Type = "utility"

    Description = @"
AnyDesk es una herramienta de acceso remoto.
Permite conectarse y controlar otros equipos a distancia de forma rapida.
Muy util para soporte tecnico, asistencia remota y administracion de sistemas.
"@

    InstallMode        = "silent"
    UninstallMode      = "none"
    VerifyAfterInstall = $true

    Dependencies = @()

    # ------------------------------------
    # Detectar si esta instalado
    # ------------------------------------
    Detect = {
        Test-Path "C:\ProgramData\BK-Launcher\AnyDesk\AnyDesk.exe"
    }

    # ------------------------------------
    # Instalacion (portable)
    # ------------------------------------
    Install = {

        Write-Host ""
        Write-Host " Descargando AnyDesk Portable..." -ForegroundColor Cyan

        $basePath = "C:\ProgramData\BK-Launcher\AnyDesk"
        $exePath  = "$basePath\AnyDesk.exe"
        $url      = "https://download.anydesk.com/AnyDesk.exe"

        if (-not (Test-Path $basePath)) {
            New-Item -ItemType Directory -Path $basePath -Force | Out-Null
        }

        Invoke-WebRequest -Uri $url -OutFile $exePath -UseBasicParsing

        Write-Host " Creando acceso directo en el escritorio..." -ForegroundColor Cyan

        $desktop = [Environment]::GetFolderPath("Desktop")
        $lnkPath = "$desktop\AnyDesk.lnk"

        $wsh = New-Object -ComObject WScript.Shell
        $lnk = $wsh.CreateShortcut($lnkPath)
        $lnk.TargetPath = $exePath
        $lnk.WorkingDirectory = $basePath
        $lnk.IconLocation = $exePath
        $lnk.Save()

        Write-Host " AnyDesk Portable instalado correctamente." -ForegroundColor Green
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {

        $basePath = "C:\ProgramData\BK-Launcher\AnyDesk"
        $desktop  = [Environment]::GetFolderPath("Desktop")
        $lnkPath  = "$desktop\AnyDesk.lnk"

        if (Test-Path $lnkPath) {
            Remove-Item $lnkPath -Force
        }

        if (Test-Path $basePath) {
            Remove-Item $basePath -Recurse -Force
        }

        Write-Host " AnyDesk Portable eliminado." -ForegroundColor Yellow
    }
}

# ========================================
# BK-Launcher V2 - App Definition
# CPU-Z Portable
# ========================================

return @{
    Id   = "cpuz"
    Name = "CPU-Z Portable"
    Type = "utility"

    Description = @"
CPU-Z es una herramienta de diagnostico de hardware en modo lectura.
Muestra informacion detallada del procesador, placa base, BIOS y memoria RAM.
No modifica el sistema y es completamente segura.
Muy utilizada para verificacion tecnica y soporte.
"@

    InstallMode        = "silent"
    UninstallMode      = "none"
    VerifyAfterInstall = $true

    Dependencies = @()

    # ------------------------------------
    # Rutas
    # ------------------------------------
    InstallDir = "C:\ProgramData\BK-Launcher\CPU-Z"
    ExePath    = "C:\ProgramData\BK-Launcher\CPU-Z\cpuz.exe"
    DesktopLnk = "$env:PUBLIC\Desktop\CPU-Z.lnk"

    # ------------------------------------
    # Detectar si esta instalado
    # ------------------------------------
    Detect = {
        Test-Path "C:\ProgramData\BK-Launcher\CPU-Z\cpuz.exe"
    }

    # ------------------------------------
    # Instalacion (portable EXE)
    # ------------------------------------
    Install = {

        Write-Host ""
        Write-Host " Descargando CPU-Z Portable..." -ForegroundColor Cyan

        $dir = "C:\ProgramData\BK-Launcher\CPU-Z"
        $exe = "$dir\cpuz.exe"
        $url = "https://download.cpuid.com/cpu-z/cpu-z_2.10-en.exe"

        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }

        Invoke-WebRequest -Uri $url -OutFile $exe -UseBasicParsing

        Write-Host " Creando acceso directo en el escritorio..." -ForegroundColor Cyan

        $wsh = New-Object -ComObject WScript.Shell
        $lnk = $wsh.CreateShortcut("$env:PUBLIC\Desktop\CPU-Z.lnk")
        $lnk.TargetPath = $exe
        $lnk.WorkingDirectory = $dir
        $lnk.IconLocation = $exe
        $lnk.Save()

        Write-Host ""
        Write-Host " CPU-Z Portable instalado correctamente." -ForegroundColor Green
    }

    # ------------------------------------
    # Desinstalacion
    # ------------------------------------
    Uninstall = {

        if (Test-Path "$env:PUBLIC\Desktop\CPU-Z.lnk") {
            Remove-Item "$env:PUBLIC\Desktop\CPU-Z.lnk" -Force
        }

        if (Test-Path "C:\ProgramData\BK-Launcher\CPU-Z") {
            Remove-Item "C:\ProgramData\BK-Launcher\CPU-Z" -Recurse -Force
        }

        Write-Host " CPU-Z Portable eliminado." -ForegroundColor Yellow
    }
}

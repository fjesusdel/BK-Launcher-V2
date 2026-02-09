# ========================================
# BK-Launcher V2 - Bootstrap (ADMIN)
# Compatible con irm | iex
# ========================================

function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

# ----------------------------------------
# Si se ejecuta via irm | iex, no hay ruta
# ----------------------------------------
if (-not $PSScriptRoot) {

    $baseDir = "C:\ProgramData\BK-Launcher-V2"

    Write-Host ""
    Write-Host "Bootstrap ejecutado sin ruta local." -ForegroundColor Yellow
    Write-Host "Descargando BK-Launcher V2 en:" -ForegroundColor Yellow
    Write-Host " $baseDir" -ForegroundColor Cyan
    Write-Host ""

    if (-not (Test-Path $baseDir)) {
        New-Item -ItemType Directory -Path $baseDir -Force | Out-Null
    }

    $zipUrl  = "https://github.com/fjesusdel/BK-Launcher-V2/archive/refs/heads/main.zip"
    $zipFile = "$env:TEMP\BK-Launcher-V2.zip"

    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile -UseBasicParsing

    Expand-Archive $zipFile -DestinationPath $baseDir -Force

    $realRoot = Join-Path $baseDir "BK-Launcher-V2-main"
    $realBootstrap = Join-Path $realRoot "bootstrap.ps1"

    Start-Process powershell `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$realBootstrap`"" `
        -Verb RunAs

    exit
}

# ----------------------------------------
# Ya ejecutando desde archivo real
# ----------------------------------------
if (-not (Test-IsAdmin)) {

    Clear-Host
    Write-Host "===============================================" -ForegroundColor Yellow
    Write-Host " BK-LAUNCHER V2" -ForegroundColor White
    Write-Host "===============================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host " El launcher requiere permisos de administrador." -ForegroundColor Yellow
    Write-Host " Se va a relanzar en modo administrador..." -ForegroundColor Yellow
    Write-Host ""

    Start-Sleep 2

    $args = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell -ArgumentList $args -Verb RunAs
    exit
}

# ----------------------------------------
# Ejecutar launcher
# ----------------------------------------
Clear-Host
Write-Host "BK-Launcher V2 iniciado con permisos de administrador." -ForegroundColor Green
Start-Sleep 1

$launcherPath = Join-Path $PSScriptRoot "launcher.ps1"

if (-not (Test-Path $launcherPath)) {
    Write-Host "Error: No se encuentra launcher.ps1" -ForegroundColor Red
    Read-Host "Pulsa ENTER para salir"
    exit
}

& $launcherPath

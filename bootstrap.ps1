# ========================================
# BK-Launcher V2 - Bootstrap (ADMIN)
# ========================================

# --- Comprobacion de permisos de administrador ---
function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

# --- Si no es admin, relanzar ---
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
    Start-Process -FilePath "powershell.exe" `
        -ArgumentList $args `
        -Verb RunAs

    exit
}

# --- Ya en modo administrador ---
Clear-Host
Write-Host "BK-Launcher V2 iniciado con permisos de administrador." -ForegroundColor Green
Start-Sleep 1

# --- Ejecutar launcher principal ---
$launcherPath = Join-Path $PSScriptRoot "launcher.ps1"

if (-not (Test-Path $launcherPath)) {
    Write-Host "Error: No se encuentra launcher.ps1" -ForegroundColor Red
    Read-Host "Pulsa ENTER para salir"
    exit
}

& $launcherPath

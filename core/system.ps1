# ========================================
# BK-Launcher V2 - System & About
# ========================================

# ----------------------------------------
# OBTENER INFORMACION DEL SISTEMA (DATOS)
# ----------------------------------------
function Get-SystemInfo {

    $os = Get-CimInstance Win32_OperatingSystem

    $isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ([Environment]::Is64BitOperatingSystem) {
        $architecture = "x64"
    } else {
        $architecture = "x86"
    }

    return @{
        OSName       = $os.Caption
        OSVersion    = $os.Version
        Architecture = $architecture
        IsAdmin      = $isAdmin
        PowerShell   = $PSVersionTable.PSVersion.ToString()
        User         = $env:USERNAME
        Computer     = $env:COMPUTERNAME
    }
}

# ----------------------------------------
# MOSTRAR INFORMACION DEL SISTEMA (MENU)
# ----------------------------------------
function Show-SystemInfo {

    Clear-Host
    UI-Header
    UI-SectionTitle "INFORMACION DEL SISTEMA"

    $info = Get-SystemInfo

    Write-Host ""
    Write-Host " Sistema operativo : $($info.OSName)" -ForegroundColor White
    Write-Host " Version           : $($info.OSVersion)" -ForegroundColor White
    Write-Host " Arquitectura      : $($info.Architecture)" -ForegroundColor White
    Write-Host ""
    Write-Host " Usuario           : $($info.User)" -ForegroundColor White
    Write-Host " Equipo            : $($info.Computer)" -ForegroundColor White
    Write-Host " PowerShell        : $($info.PowerShell)" -ForegroundColor White
    Write-Host ""
    Write-Host " Permisos          : " -NoNewline -ForegroundColor White

    if ($info.IsAdmin) {
        Write-Host "Administrador" -ForegroundColor Green
    } else {
        Write-Host "No administrador" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host " Ruta del launcher : $PSScriptRoot" -ForegroundColor DarkGray
    Write-Host ""

    Read-Host " Pulsa ENTER para volver al menu"
}

# ----------------------------------------
# ACERCA DE
# ----------------------------------------
function Show-About {

    Clear-Host
    UI-Header
    UI-SectionTitle "ACERCA DE"

    Write-Host ""
    Write-Host " BK-LAUNCHER V2" -ForegroundColor White
    Write-Host ""
    Write-Host " Sistema de gestion e instalacion de software" -ForegroundColor Gray
    Write-Host ""
    Write-Host " Autor   : Fran Delgado" -ForegroundColor Gray
    Write-Host " Version : 2.0" -ForegroundColor Gray
    Write-Host " Estado  : Estable" -ForegroundColor Green
    Write-Host ""
    Write-Host " Funciones principales:" -ForegroundColor Yellow
    Write-Host "  - Instalacion multiple de aplicaciones" -ForegroundColor White
    Write-Host "  - Instaladores interactivos y silenciosos" -ForegroundColor White
    Write-Host "  - Resolucion de dependencias" -ForegroundColor White
    Write-Host "  - Herramientas externas y scripts remotos" -ForegroundColor White
    Write-Host ""
    Write-Host " Proyecto personal - uso no comercial" -ForegroundColor DarkGray
    Write-Host ""

    Read-Host " Pulsa ENTER para volver al menu"
}

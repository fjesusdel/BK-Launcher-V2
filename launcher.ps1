# ========================================
# BK-Launcher V2 - Main Launcher
# ========================================

. "$PSScriptRoot\config\settings.ps1"
. "$PSScriptRoot\core\system.ps1"
. "$PSScriptRoot\core\engine.ps1"
. "$PSScriptRoot\core\menu.ps1"
. "$PSScriptRoot\core\ui.ps1"

Load-Apps "$PSScriptRoot\apps"

# ----------------------------------------
function Handle-Install {

    $apps = $Global:BK_Apps
    $selected = Show-MultiSelectMenu -Apps $apps -Title "INSTALAR APLICACIONES"

    if ($selected.Count -eq 0) { return }

    try {
        $plan = Get-InstallPlan -SelectedApps $selected
    } catch {
        Write-Host ""
        Write-Host " Error resolviendo dependencias:" -ForegroundColor Red
        Write-Host " $_" -ForegroundColor Red
        Read-Host " Pulsa ENTER para volver"
        return
    }

    foreach ($app in $plan) {

        if (Test-AppInstalled $app) {
            Write-Host " $($app.Name) ya instalada. Se omite." -ForegroundColor DarkGray
            continue
        }

        Write-Host ""
        UI-Line "-" 60 DarkGray
        Write-Host " Instalando $($app.Name)..." -ForegroundColor Cyan
        UI-Line "-" 60 DarkGray

        $result = Invoke-AppAction -App $app -Action "install"

        if ($result.Success) {
            Write-Host " Estado: $($result.Message)" -ForegroundColor Green
        } else {
            Write-Host " Error: $($result.Message)" -ForegroundColor Red
            Read-Host " Instalacion detenida. Pulsa ENTER"
            return
        }
    }

    Read-Host " Instalacion completada. Pulsa ENTER"
}

# ----------------------------------------
function Handle-Uninstall {

    $apps = $Global:BK_Apps
    $selected = Show-MultiSelectMenu -Apps $apps -Title "DESINSTALAR APLICACIONES"

    if ($selected.Count -eq 0) { return }

    foreach ($app in $selected) {

        if (-not (Test-AppInstalled $app)) {
            Write-Host " $($app.Name) no esta instalada. Se omite." -ForegroundColor DarkGray
            continue
        }

        Write-Host ""
        UI-Line "-" 60 DarkGray
        Write-Host " Desinstalando $($app.Name)..." -ForegroundColor Cyan
        UI-Line "-" 60 DarkGray

        $result = Invoke-AppAction -App $app -Action "uninstall"
        Write-Host " Estado: $($result.Message)" -ForegroundColor Yellow
    }

    Read-Host " Proceso de desinstalacion finalizado. Pulsa ENTER"
}

# ----------------------------------------
function Show-SystemInfo {

    UI-Header
    UI-SectionTitle "INFORMACION DEL SISTEMA"

    $os = Get-CimInstance Win32_OperatingSystem
    $isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    Write-Host " Sistema operativo : $($os.Caption)" -ForegroundColor White
    Write-Host " Version           : $($os.Version)" -ForegroundColor White
    Write-Host " Arquitectura      : $($os.OSArchitecture)" -ForegroundColor White
    Write-Host ""
    Write-Host " Usuario           : $env:USERNAME" -ForegroundColor White
    Write-Host " Equipo            : $env:COMPUTERNAME" -ForegroundColor White
    Write-Host " PowerShell        : $($PSVersionTable.PSVersion)" -ForegroundColor White
    Write-Host ""
    Write-Host " Permisos          : " -NoNewline -ForegroundColor White
    if ($isAdmin) {
        Write-Host "Administrador" -ForegroundColor Green
    } else {
        Write-Host "No administrador" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host " Ruta launcher     : $PSScriptRoot" -ForegroundColor DarkGray

    Read-Host " Pulsa ENTER para volver"
}

# ----------------------------------------
function Show-About {

    UI-Header
    UI-SectionTitle "ACERCA DE"

    Write-Host " BK-LAUNCHER V2" -ForegroundColor White
    Write-Host ""
    Write-Host " Sistema modular de instalacion y gestion de software" -ForegroundColor Gray
    Write-Host ""
    Write-Host " Autor      : Fran Delgado" -ForegroundColor Gray
    Write-Host " Proyecto   : BK-Launcher" -ForegroundColor Gray
    Write-Host " Version    : 2.0" -ForegroundColor Gray
    Write-Host " Estado     : Estable" -ForegroundColor Gray
    Write-Host ""
    Write-Host " Funciones principales:" -ForegroundColor Yellow
    Write-Host "  - Instalacion multiple de aplicaciones" -ForegroundColor White
    Write-Host "  - Resolucion automatica de dependencias" -ForegroundColor White
    Write-Host "  - Desinstalacion segura sin bloqueos" -ForegroundColor White
    Write-Host "  - Soporte para apps interactivas y manuales" -ForegroundColor White
    Write-Host "  - Soporte para Rainmeter y skins" -ForegroundColor White
    Write-Host ""
    Write-Host " Notas:" -ForegroundColor Yellow
    Write-Host "  - Algunas apps pueden requerir confirmacion manual" -ForegroundColor White
    Write-Host "  - Algunas desinstalaciones pueden solicitar reinicio" -ForegroundColor White
    Write-Host "  - El estado final se valida en el siguiente arranque" -ForegroundColor White

    Read-Host " Pulsa ENTER para volver"
}

# ----------------------------------------
function Show-MainMenu {

    UI-Header
    UI-SectionTitle "MENU PRINCIPAL"

    UI-MenuOption "1" "Instalar aplicaciones"
    UI-MenuOption "2" "Desinstalar aplicaciones"
    UI-MenuOption "3" "Informacion del sistema"
    UI-MenuOption "4" "Acerca de"
    Write-Host ""
    UI-MenuOption "0" "Salir" Red White
    Write-Host ""

    UI-Footer
    switch (Read-Host) {
        "1" { Handle-Install }
        "2" { Handle-Uninstall }
        "3" { Show-SystemInfo }
        "4" { Show-About }
        "0" { exit }
    }
}

# ----------------------------------------
while ($true) {
    Show-MainMenu
}
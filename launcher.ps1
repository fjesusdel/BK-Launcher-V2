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

    # ---- AVISO PREVIO SI HAY APPS INTERACTIVAS ----
    $interactiveApps = $plan | Where-Object {
        $_.ContainsKey("InstallMode") -and $_.InstallMode -eq "interactive"
    }

    if ($interactiveApps.Count -gt 0) {
        Clear-Host
        UI-Header
        UI-SectionTitle "AVISO IMPORTANTE"

        Write-Host ""
        Write-Host " Se van a lanzar uno o mas instaladores oficiales externos." -ForegroundColor Yellow
        Write-Host ""
        Write-Host " Durante el proceso:" -ForegroundColor Yellow
        Write-Host "  - Apareceran ventanas de instalacion independientes" -ForegroundColor Yellow
        Write-Host "  - El launcher puede quedar en segundo plano" -ForegroundColor Yellow
        Write-Host "  - El proceso puede tardar unos segundos entre aplicaciones" -ForegroundColor Yellow
        Write-Host ""
        Write-Host " Esto es normal. No cierres el launcher." -ForegroundColor Yellow
        Write-Host ""
        Write-Host " Cuando pulses ENTER comenzara la instalacion." -ForegroundColor Cyan
        Write-Host ""

        Read-Host " Pulsa ENTER para continuar"
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

        if (-not $result.Success) {
            Write-Host " Error: $($result.Message)" -ForegroundColor Red
            Read-Host " Instalacion detenida. Pulsa ENTER"
            return
        }

        if ($app.ContainsKey("InstallMode") -and $app.InstallMode -eq "interactive") {
            continue
        }

        Write-Host " Estado: $($result.Message)" -ForegroundColor Green
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

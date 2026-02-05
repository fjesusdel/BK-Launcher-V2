# ========================================
# BK-Launcher V2 - Main Launcher
# ========================================

. "$PSScriptRoot\config\settings.ps1"
. "$PSScriptRoot\core\system.ps1"
. "$PSScriptRoot\core\engine.ps1"
. "$PSScriptRoot\core\menu.ps1"

$Global:SystemInfo = Get-SystemInfo
Load-Apps "$PSScriptRoot\apps"

# ----------------------------------------
function Handle-Install {
    $apps = $Global:BK_Apps
    $selected = Show-MultiSelectMenu -Apps $apps -Title "INSTALAR APLICACIONES"

    if ($selected.Count -eq 0) { return }

    try {
        $plan = Get-InstallPlan -SelectedApps $selected
    } catch {
        Write-Host "Error resolviendo dependencias: $_" -ForegroundColor Red
        Read-Host "Pulsa ENTER para volver"
        return
    }

    foreach ($app in $plan) {
        if (Test-AppInstalled $app) {
            Write-Host "$($app.Name) ya instalada. Se omite." -ForegroundColor Gray
            continue
        }

        Write-Host "Instalando $($app.Name)..." -ForegroundColor Cyan
        $result = Invoke-AppAction -App $app -Action "install"

        if ($result.Success) {
            Write-Host "$($app.Name): $($result.Message)" -ForegroundColor Green
        } else {
            Write-Host "$($app.Name): $($result.Message)" -ForegroundColor Red
            Read-Host "Instalacion detenida. Pulsa ENTER"
            return
        }
    }

    Read-Host "Instalacion completada. Pulsa ENTER"
}

# ----------------------------------------
function Show-MainMenu {
    Clear-Host
    Write-Host "BK-Launcher V2" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1 - Instalar aplicaciones"
    Write-Host "2 - Desinstalar aplicaciones"
    Write-Host "3 - Instalar paquetes"
    Write-Host "4 - Acerca de"
    Write-Host "0 - Salir"
    Write-Host ""

    switch (Read-Host "Seleccion") {
        "1" { Handle-Install }
        "0" { exit }
    }
}

# ----------------------------------------
while ($true) {
    Show-MainMenu
}

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
function Show-MainMenu {
    Clear-Host

    Write-Host "================================" -ForegroundColor $Color_Title
    Write-Host "   $TXT_MainMenu_Title"           -ForegroundColor $Color_Title
    Write-Host "================================" -ForegroundColor $Color_Title
    Write-Host ""

    Write-Host "1 - Instalar aplicaciones"   -ForegroundColor $Color_Menu
    Write-Host "2 - Desinstalar aplicaciones" -ForegroundColor $Color_Menu
    Write-Host "3 - Instalar paquetes"        -ForegroundColor $Color_Menu
    Write-Host "4 - Acerca de"                -ForegroundColor $Color_Menu
    Write-Host "0 - Salir"                     -ForegroundColor $Color_Menu
    Write-Host ""

    switch (Read-Host "Selecciona una opcion") {
        "1" { Handle-Install }
        "2" { Handle-Uninstall }
        "3" { Pause-Placeholder }
        "4" { Show-About }
        "0" { exit }
    }
}

# ----------------------------------------
function Handle-Install {
    $apps = $Global:BK_Apps
    $selected = Show-MultiSelectMenu -Apps $apps -Title "INSTALAR APLICACIONES"

    foreach ($app in $selected) {
        if (Test-AppInstalled $app) {
            Write-Host "$($app.Name) ya estaba instalada. Se omite." -ForegroundColor $Color_Info
            continue
        }

        Write-Host "Instalando $($app.Name)..." -ForegroundColor $Color_Info
        $result = Invoke-AppAction -App $app -Action "install"

        if ($result.Success) {
            Write-Host "$($app.Name): $($result.Message)" -ForegroundColor $Color_Success
        }
        else {
            Write-Host "$($app.Name): $($result.Message)" -ForegroundColor $Color_Error
        }
    }

    Read-Host "Pulsa ENTER para volver"
}

# ----------------------------------------
function Handle-Uninstall {
    $apps = $Global:BK_Apps
    $selected = Show-MultiSelectMenu -Apps $apps -Title "DESINSTALAR APLICACIONES"

    foreach ($app in $selected) {
        if (-not (Test-AppInstalled $app)) {
            Write-Host "$($app.Name) no esta instalada. Se omite." -ForegroundColor $Color_Info
            continue
        }

        Write-Host "Desinstalando $($app.Name)..." -ForegroundColor $Color_Info
        $result = Invoke-AppAction -App $app -Action "uninstall"

        if ($result.Success) {
            Write-Host "$($app.Name): $($result.Message)" -ForegroundColor $Color_Success
        }
        else {
            Write-Host "$($app.Name): $($result.Message)" -ForegroundColor $Color_Error
        }
    }

    Read-Host "Pulsa ENTER para volver"
}

# ----------------------------------------
function Show-About {
    Clear-Host
    Write-Host "BK-Launcher V2" -ForegroundColor $Color_Title
    Write-Host "Autor   : $BK_Author"
    Write-Host "Version : $BK_Version"
    Write-Host ""
    Read-Host "Pulsa ENTER para volver"
}

function Pause-Placeholder {
    Write-Host ""
    Write-Host "Funcion no implementada aun" -ForegroundColor $Color_Info
    Read-Host "Pulsa ENTER para volver"
}

# ----------------------------------------
while ($true) {
    Show-MainMenu
}

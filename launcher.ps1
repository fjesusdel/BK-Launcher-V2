# ========================================
# BK-Launcher V2 - Main Launcher
# ========================================

# Load global settings
. "$PSScriptRoot\config\settings.ps1"

# Load system detection
. "$PSScriptRoot\core\system.ps1"

# Load core engine
. "$PSScriptRoot\core\engine.ps1"

# Load menus
. "$PSScriptRoot\core\menu.ps1"

# Detect system once at startup
$Global:SystemInfo = Get-SystemInfo

# Load apps
Load-Apps "$PSScriptRoot\apps"

# ----------------------------------------
# Main Menu
# ----------------------------------------
function Show-MainMenu {
    Clear-Host

    Write-Host "================================" -ForegroundColor $Color_Title
    Write-Host "   $TXT_MainMenu_Title"           -ForegroundColor $Color_Title
    Write-Host "================================" -ForegroundColor $Color_Title
    Write-Host ""

    Write-Host $TXT_MainMenu_Install   -ForegroundColor $Color_Menu
    Write-Host $TXT_MainMenu_Uninstall -ForegroundColor $Color_Menu
    Write-Host $TXT_MainMenu_Packages  -ForegroundColor $Color_Menu
    Write-Host $TXT_MainMenu_About     -ForegroundColor $Color_Menu
    Write-Host $TXT_MainMenu_Exit      -ForegroundColor $Color_Menu
    Write-Host ""

    $choice = Read-Host $TXT_MainMenu_Select

    switch ($choice) {
        "1" {
            $apps = $Global:BK_Apps
            $selectedApps = Show-MultiSelectMenu -Apps $apps -Title "INSTALAR APLICACIONES"

            foreach ($app in $selectedApps) {
                $installed = $false
                if ($app.Detect) {
                    $installed = & $app.Detect
                }

                if ($installed) {
                    Write-Host "$($app.Name) ya estaba instalada. Se omite." -ForegroundColor $Color_Info
                    continue
                }

                Write-Host "Instalando $($app.Name)..." -ForegroundColor $Color_Info
                $result = Invoke-AppAction -App $app -Action "install"

                if ($result.Success) {
                    Write-Host "$($app.Name) instalada correctamente." -ForegroundColor $Color_Success
                }
                else {
                    Write-Host "Error instalando $($app.Name): $($result.Message)" -ForegroundColor $Color_Error
                }
            }

            Read-Host "Pulsa ENTER para volver"
        }
        "2" { Pause-Placeholder }
        "3" { Pause-Placeholder }
        "4" { Show-About }
        "0" { exit }
        default {
            Write-Host "Opcion invalida" -ForegroundColor $Color_Error
            Start-Sleep 1
        }
    }
}

# ----------------------------------------
# About Section
# ----------------------------------------
function Show-About {
    Clear-Host

    Write-Host "--------------------------------" -ForegroundColor $Color_Title
    Write-Host "   $TXT_About_Title"               -ForegroundColor $Color_Title
    Write-Host "--------------------------------" -ForegroundColor $Color_Title
    Write-Host ""

    Write-Host "$TXT_About_Project : $BK_ProjectName" -ForegroundColor $Color_Info
    Write-Host "$TXT_About_Version : $BK_Version"     -ForegroundColor $Color_Info
    Write-Host "$TXT_About_Author  : $BK_Author"      -ForegroundColor $Color_Info
    Write-Host ""
    Write-Host $BK_Description                         -ForegroundColor $Color_Info

    Write-Host ""
    Write-Host "Sistema detectado:"                    -ForegroundColor $Color_Info
    Write-Host "OS       : $($SystemInfo.OSName)"      -ForegroundColor $Color_Info
    Write-Host "Version  : $($SystemInfo.OSVersion)"  -ForegroundColor $Color_Info
    Write-Host "Arquitect: $($SystemInfo.Architecture)" -ForegroundColor $Color_Info
    Write-Host "Admin    : $($SystemInfo.IsAdmin)"     -ForegroundColor $Color_Info
    Write-Host "PowerSh  : $($SystemInfo.PowerShell)"  -ForegroundColor $Color_Info

    Write-Host ""
    Read-Host $TXT_About_Back
}

# ----------------------------------------
# Placeholder
# ----------------------------------------
function Pause-Placeholder {
    Write-Host ""
    Write-Host $TXT_NotImplemented -ForegroundColor $Color_Info
    Read-Host $TXT_About_Back
}

# ----------------------------------------
# Main Loop
# ----------------------------------------
while ($true) {
    Show-MainMenu
}

# ========================================
# BK-Launcher V2 - Main Launcher
# ========================================

# Load settings
. "$PSScriptRoot\config\settings.ps1"

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
        "1" { Pause-Placeholder }
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
    Read-Host $TXT_About_Back
}

function Pause-Placeholder {
    Write-Host ""
    Write-Host $TXT_NotImplemented -ForegroundColor $Color_Info
    Read-Host $TXT_About_Back
}

# Main loop
while ($true) {
    Show-MainMenu
}

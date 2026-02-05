# ========================================
# BK-Launcher V2 - UI Helpers (ASCII ONLY)
# ========================================

function UI-Line {
    param (
        [string]$Char = "=",
        [int]$Length = 60,
        [ConsoleColor]$Color = "Cyan"
    )

    Write-Host ($Char * $Length) -ForegroundColor $Color
}

function UI-Header {
    Clear-Host
    UI-Line "=" 60 Cyan
    Write-Host "                    BK-LAUNCHER V2" -ForegroundColor White
    UI-Line "=" 60 Cyan
    Write-Host " Sistema de gestion e instalacion de software" -ForegroundColor DarkGray
    Write-Host " Autor  : Fran Delgado" -ForegroundColor DarkGray
    Write-Host " Version: 2.0" -ForegroundColor DarkGray
    UI-Line "-" 60 DarkGray
    Write-Host ""
}

function UI-SectionTitle {
    param ([string]$Title)

    Write-Host ""
    Write-Host " $Title" -ForegroundColor Yellow
    UI-Line "-" 60 DarkGray
    Write-Host ""
}

function UI-MenuOption {
    param (
        [string]$Key,
        [string]$Text,
        [ConsoleColor]$KeyColor = "Green",
        [ConsoleColor]$TextColor = "White"
    )

    Write-Host "   [$Key] " -NoNewline -ForegroundColor $KeyColor
    Write-Host $Text -ForegroundColor $TextColor
}

function UI-Footer {
    UI-Line "-" 60 DarkGray
    Write-Host " Seleccion: " -NoNewline -ForegroundColor White
}

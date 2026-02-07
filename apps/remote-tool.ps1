# ========================================
# BK-Launcher V2 - App Definition
# Remote Tool (Massgrave)
# ========================================

return @{
    Id   = "remote-tool"
    Name = "Activacion de Windows y Office by Massgrave.dev"
    Type = "utility"

    InstallMode        = "interactive"
    UninstallMode      = "none"
    VerifyAfterInstall = $false

    Dependencies = @()

    # Nunca se considera instalada
    Detect = { $false }

    # ------------------------------------
    # "Instalacion" = lanzar script externo
    # ------------------------------------
    Install = {

        Write-Host ""
        Write-Host " Se va a abrir el menu de Massgrave en una nueva ventana." -ForegroundColor Cyan
        Write-Host " El launcher seguira funcionando con normalidad." -ForegroundColor Cyan
        Write-Host ""
        Write-Host " Cuando termines, vuelve aqui y pulsa ENTER." -ForegroundColor Yellow
        Write-Host ""

        Start-Process powershell `
            -ArgumentList '-NoProfile -ExecutionPolicy Bypass -NoExit -Command "irm https://get.activated.win/ | iex"'

        Read-Host " Pulsa ENTER para continuar"
    }
}

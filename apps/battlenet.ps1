# ========================================
# BK-Launcher V2 - App Definition
# Battle.net
# ========================================

return @{
    Id                 = "battlenet"
    Name               = "Battle.net"
    Type               = "app"

    InstallMode        = "interactive"
    UninstallMode      = "manual"
    VerifyAfterInstall = $true

    Dependencies       = @()

    Detect = {
        Test-Path "C:\Program Files (x86)\Battle.net\Battle.net.exe"
    }

    Install = {
        $url  = "https://www.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
        $dest = "$env:TEMP\Battle.net-Setup.exe"

        Write-Host " Descargando Battle.net..."
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

        Write-Host " Lanzando instalador oficial..."
        Start-Process $dest
    }

    Uninstall = {
        Write-Host ""
        Write-Host " La desinstalacion de Battle.net es manual." -ForegroundColor Yellow
        Write-Host " Se abrira el panel de aplicaciones de Windows." -ForegroundColor Yellow
        Write-Host ""

        Start-Process "ms-settings:appsfeatures"
    }
}

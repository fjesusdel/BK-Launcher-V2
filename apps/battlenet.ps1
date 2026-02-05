# ========================================
# BK-Launcher V2 - App Definition
# Battle.net
# ========================================

return @{
    Id            = "battlenet"
    Name          = "Battle.net"
    Type          = "binary"

    InstallMode   = "silent"
    UninstallMode = "manual"

    Dependencies  = @()

    Detect = {
        Test-Path "C:\Program Files (x86)\Battle.net\Battle.net.exe"
    }

    Install = {
        $url  = "https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
        $dest = "$env:TEMP\BattleNetSetup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process -FilePath $dest -Wait
    }

    Uninstall = {
        Write-Host "Battle.net requiere desinstalacion manual." -ForegroundColor Yellow
        Write-Host "Se abrira la ventana de Aplicaciones de Windows."
        Start-Sleep 2
        Start-Process "ms-settings:appsfeatures"
    }
}

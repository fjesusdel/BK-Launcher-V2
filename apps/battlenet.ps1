# ========================================
# BK-Launcher V2 - App Definition
# Battle.net
# ========================================

return @{
    Id           = "battlenet"
    Name         = "Battle.net"
    Type         = "binary"
    InstallMode  = "silent"
    Dependencies = @()

    Detect = {
        Test-Path "C:\Program Files (x86)\Battle.net\Battle.net.exe"
    }

    Install = {
        $url  = "https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
        $dest = "$env:TEMP\BattleNetSetup.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process -FilePath $dest -ArgumentList "--lang=esES --installpath=`"C:\Program Files (x86)\Battle.net`"" -Wait
    }

    Uninstall = {
        $uninstallPath = "C:\Program Files (x86)\Battle.net\Battle.net Uninstaller.exe"
        if (Test-Path $uninstallPath) {
            Start-Process -FilePath $uninstallPath -Wait
        }
    }
}

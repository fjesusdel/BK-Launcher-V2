# ========================================
# BK-Launcher V2 - App Definition
# WinRAR
# ========================================

return @{
    Id            = "winrar"
    Name          = "WinRAR"
    Type          = "binary"

    InstallMode   = "silent"
    UninstallMode = "interactive"

    Dependencies  = @()

    Detect = {
        Test-Path "C:\Program Files\WinRAR\WinRAR.exe"
    }

    Install = {
        $url  = "https://www.rarlab.com/rar/winrar-x64-701.exe"
        $dest = "$env:TEMP\winrar.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Start-Process $dest -ArgumentList "/S" -Wait
    }

    Uninstall = {
        $key = Get-ItemProperty `
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" `
            -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "WinRAR*" } |
            Select-Object -First 1

        if ($key -and $key.UninstallString) {
            Start-Process "cmd.exe" `
                -ArgumentList "/c `"$($key.UninstallString)`"" `
                -Wait
        }
    }
}

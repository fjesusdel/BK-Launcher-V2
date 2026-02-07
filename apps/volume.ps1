# ========================================
# BK-Launcher V2 - App Definition
# Control de volumen BK
# ========================================

return @{
    Id                  = "volume"
    Name                = "Control de volumen BK"
    Type                = "utility"

    Description = @"
Herramienta propia de BK-Launcher para controlar el volumen del sistema.
Permite subir, bajar y silenciar el audio mediante atajos de teclado.
Muestra un indicador visual en pantalla y se inicia automaticamente con Windows.
"@

    InstallMode         = "interactive"
    UninstallMode       = "silent"
    VerifyAfterInstall  = $false

    Dependencies        = @("autohotkey")

    Detect = {
        Test-Path "C:\ProgramData\BK-Launcher\VolumeControl\volume.ahk"
    }

    Install = {

        $basePath   = "C:\ProgramData\BK-Launcher\VolumeControl"
        $scriptPath = "$basePath\volume.ahk"
        $startup    = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
        $lnkPath    = "$startup\Control de volumen BK.lnk"

        Write-Host ""
        Write-Host "CONTROL DE VOLUMEN BK" -ForegroundColor Cyan
        Write-Host "----------------------"
        Write-Host "Se iniciara automaticamente con Windows."
        Write-Host ""
        Write-Host "Atajos:"
        Write-Host "  CTRL + Flecha Arriba  -> Subir volumen"
        Write-Host "  CTRL + Flecha Abajo   -> Bajar volumen"
        Write-Host "  CTRL + M              -> Mute / Unmute"
        Write-Host ""

        New-Item -ItemType Directory -Path $basePath -Force | Out-Null

        $ahkCode = @'
#NoEnv
#SingleInstance Force
SetBatchLines -1

; =========================
; CONFIGURACION
; =========================
STEP=5
OSD_TIME=4000

; =========================
; ATAJOS
; Ctrl + Flechas / Ctrl + M
; =========================
^Up::
    SoundGet, VOL
    VOL += %STEP%
    if VOL > 100
        VOL = 100
    SoundSet, %VOL%
    Gosub, SHOW_OSD
return

^Down::
    SoundGet, VOL
    VOL -= %STEP%
    if VOL < 0
        VOL = 0
    SoundSet, %VOL%
    Gosub, SHOW_OSD
return

^m::
    SoundSet, +1, , mute
    Gosub, SHOW_OSD
return

; =========================
; HUD
; =========================
SHOW_OSD:
    Gui, Destroy
    Gui, +AlwaysOnTop -Caption +ToolWindow
    Gui, Color, 1A1A1A

    Gui, Font, s10 cFFFFFF, Consolas
    Gui, Add, Text, x10 y8, BLACK CONSOLE :: AUDIO

    SoundGet, MUTE, , mute
    SoundGet, VOL
    VOL := Round(VOL)

    if (MUTE = "On")
    {
        Gui, Font, s10 cFF3C82, Consolas
        Gui, Add, Text, x10 y28, MUTED
        BAR=0
    }
    else
    {
        Gui, Font, s10 cB45AFF, Consolas
        Gui, Add, Text, x10 y28, VOLUME : %VOL%`%
        BAR=%VOL%
    }

    Gui, Add, Progress, x10 y52 w200 h8 cB45AFF Background1A1A1A, %BAR%
    Gui, Show, NoActivate x50 y50

    SetTimer, HIDE_OSD, -%OSD_TIME%
return

HIDE_OSD:
    Gui, Destroy
return
'@

        Set-Content -Path $scriptPath -Value $ahkCode -Encoding ASCII

        $wsh = New-Object -ComObject WScript.Shell
        $lnk = $wsh.CreateShortcut($lnkPath)
        $lnk.TargetPath = "autohotkey.exe"
        $lnk.Arguments  = "`"$scriptPath`""
        $lnk.WorkingDirectory = $basePath
        $lnk.Save()

        Start-Process "autohotkey.exe" -ArgumentList "`"$scriptPath`""
    }

    Uninstall = {

        $basePath = "C:\ProgramData\BK-Launcher\VolumeControl"
        $lnkPath  = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Control de volumen BK.lnk"

        Get-Process autohotkey -ErrorAction SilentlyContinue |
            Stop-Process -Force -ErrorAction SilentlyContinue

        Start-Sleep 2

        if (Test-Path $basePath) {
            Remove-Item -Path $basePath -Recurse -Force -ErrorAction SilentlyContinue
        }

        if (Test-Path $lnkPath) {
            Remove-Item $lnkPath -Force
        }

        Write-Host "Control de volumen BK eliminado correctamente." -ForegroundColor Yellow
    }
}

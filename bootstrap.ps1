# ========================================
# BK-Launcher V2 - Bootstrap
# ========================================

function Test-IsAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    Write-Host "Relanzando BK-Launcher V2 con permisos de administrador..."
    Start-Sleep 1

    Start-Process powershell `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\launcher.ps1`"" `
        -Verb RunAs

    exit
}

# Ya somos admin, lanzamos el launcher
powershell -ExecutionPolicy Bypass -File "$PSScriptRoot\launcher.ps1"

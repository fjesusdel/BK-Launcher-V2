# ========================================
# BK-Launcher V2 - Core Engine (FINAL)
# ========================================

$Global:BK_Apps = @()

# ----------------------------------------
function Load-Apps {
    param ([string]$AppsPath)

    $Global:BK_Apps = @()
    if (-not (Test-Path $AppsPath)) { return }

    Get-ChildItem -Path $AppsPath -Filter "*.ps1" | ForEach-Object {
        try {
            $app = . $_.FullName
            if ($app -and $app.Id) {
                $Global:BK_Apps += $app
            }
        } catch {}
    }
}

# ----------------------------------------
function Get-AppById {
    param ([string]$Id)
    $Global:BK_Apps | Where-Object { $_.Id -eq $Id }
}

# ----------------------------------------
function Test-AppInstalled {
    param ([hashtable]$App)

    if (-not $App.Detect) { return $false }
    try { & $App.Detect } catch { return $false }
}

# ----------------------------------------
# Dependency resolution
# ----------------------------------------
function Resolve-Dependencies {
    param (
        [hashtable]$App,
        [hashtable]$Resolved,
        [hashtable]$Seen
    )

    if ($Seen[$App.Id]) {
        throw "Dependencia circular detectada: $($App.Id)"
    }

    if ($Resolved[$App.Id]) {
        return
    }

    $Seen[$App.Id] = $true

    foreach ($depId in $App.Dependencies) {
        $dep = Get-AppById $depId
        if (-not $dep) {
            throw "Dependencia no encontrada: $depId"
        }
        Resolve-Dependencies -App $dep -Resolved $Resolved -Seen $Seen
    }

    $Resolved[$App.Id] = $App
}

function Get-InstallPlan {
    param ([array]$SelectedApps)

    $resolved = @{}
    foreach ($app in $SelectedApps) {
        Resolve-Dependencies -App $app -Resolved $resolved -Seen @{}
    }

    return $resolved.Values
}

# ----------------------------------------
function Invoke-AppAction {
    param (
        [hashtable]$App,
        [ValidateSet("install","uninstall")]
        [string]$Action
    )

    if (-not $App.ContainsKey($Action)) {
        return @{ Success=$false; Message="Accion no soportada" }
    }

    try {
        & $App[$Action]
    } catch {
        return @{ Success=$false; Message=$_.Exception.Message }
    }

    # --- REGLA DEFINITIVA ---
    # Nunca verificamos DESINSTALACIONES
    if ($Action -eq "uninstall") {
        return @{
            Success = $true
            Message = "Desinstalacion iniciada"
        }
    }

    # --- Instalaciones ---
    $verify = $true
    if ($App.ContainsKey("VerifyAfterInstall")) {
        $verify = [bool]$App.VerifyAfterInstall
    }

    if (-not $verify) {
        return @{
            Success = $true
            Message = "Instalacion iniciada (verificacion manual)"
        }
    }

    # Verificacion basica de instalacion
    for ($i = 0; $i -lt 30; $i++) {
        if (Test-AppInstalled $App) {
            return @{
                Success = $true
                Message = "Instalacion confirmada"
            }
        }
        Start-Sleep 2
    }

    return @{
        Success = $false
        Message = "No se pudo verificar la instalacion"
    }
}
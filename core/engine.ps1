# ========================================
# BK-Launcher V2 - Core Engine
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
    return $Global:BK_Apps | Where-Object { $_.Id -eq $Id }
}

# ----------------------------------------
function Test-AppInstalled {
    param ([hashtable]$App)

    if (-not $App.Detect) { return $false }
    try { return & $App.Detect } catch { return $false }
}

# ----------------------------------------
function Wait-ForAppState {
    param (
        [hashtable]$App,
        [bool]$ExpectedState,
        [int]$TimeoutSeconds = 60
    )

    $elapsed = 0
    while ($elapsed -lt $TimeoutSeconds) {
        if ((Test-AppInstalled $App) -eq $ExpectedState) {
            return $true
        }
        Start-Sleep 2
        $elapsed += 2
    }
    return $false
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

    $expectedState = ($Action -eq "install")

    try {
        & $App[$Action]
    } catch {
        return @{ Success=$false; Message=$_.Exception.Message }
    }

    if (Wait-ForAppState -App $App -ExpectedState $expectedState) {
        return @{
            Success = $true
            Message = if ($expectedState) {
                "Instalacion confirmada"
            } else {
                "Desinstalacion confirmada"
            }
        }
    }

    return @{
        Success = $false
        Message = "No se pudo confirmar el cambio"
    }
}

# ----------------------------------------
# Dependency resolution (recursive, ordered)
# ----------------------------------------
function Resolve-Dependencies {
    param (
        [hashtable]$App,
        [hashtable]$Resolved,
        [hashtable]$Seen
    )

    if ($Seen[$App.Id]) {
        throw "Dependencia circular detectada en $($App.Id)"
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

# ----------------------------------------
function Get-InstallPlan {
    param ([array]$SelectedApps)

    $resolved = @{}
    foreach ($app in $SelectedApps) {
        Resolve-Dependencies -App $app -Resolved $resolved -Seen @{}
    }

    return $resolved.Values
}

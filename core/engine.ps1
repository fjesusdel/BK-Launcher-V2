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
function Test-AppInstalled {
    param ([hashtable]$App)

    if (-not $App.Detect) { return $false }

    try {
        return & $App.Detect
    } catch {
        return $false
    }
}

# ----------------------------------------
function Wait-ForAppState {
    param (
        [hashtable]$App,
        [bool]$ExpectedState,
        [int]$TimeoutSeconds = 40
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
        [Parameter(Mandatory)]
        [hashtable]$App,

        [Parameter(Mandatory)]
        [ValidateSet("install", "uninstall")]
        [string]$Action
    )

    if (-not $App.ContainsKey($Action)) {
        return @{
            Success = $false
            Message = "Accion no soportada"
        }
    }

    $expectedState = ($Action -eq "install")

    try {
        & $App[$Action]
    }
    catch {
        return @{
            Success = $false
            Message = $_.Exception.Message
        }
    }

    $verified = Wait-ForAppState -App $App -ExpectedState $expectedState

    if ($verified) {
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
        Message = "La accion se ejecuto, pero el sistema no confirmo el cambio a tiempo"
    }
}

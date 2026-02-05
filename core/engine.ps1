# ========================================
# BK-Launcher V2 - Core Engine
# ========================================

# Global app registry
$Global:BK_Apps = @()

# ----------------------------------------
# Load all app definitions
# ----------------------------------------
function Load-Apps {
    param (
        [string]$AppsPath
    )

    $Global:BK_Apps = @()

    if (-not (Test-Path $AppsPath)) {
        return
    }

    Get-ChildItem -Path $AppsPath -Filter "*.ps1" | ForEach-Object {
        try {
            $app = . $_.FullName
            if ($null -ne $app -and $app.Id) {
                $Global:BK_Apps += $app
            }
        }
        catch {
            # Ignore broken apps for now
        }
    }
}

# ----------------------------------------
# App helpers
# ----------------------------------------
function Test-AppInstalled {
    param (
        [hashtable]$App
    )

    if (-not $App.Detect) {
        return $false
    }

    try {
        return & $App.Detect
    }
    catch {
        return $false
    }
}

# ----------------------------------------
# Execute app action with verification
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

    $before = Test-AppInstalled $App

    try {
        & $App[$Action]
    }
    catch {
        return @{
            Success = $false
            Message = $_.Exception.Message
        }
    }

    Start-Sleep 2

    $after = Test-AppInstalled $App

    if ($Action -eq "install" -and -not $before -and $after) {
        return @{
            Success = $true
            Message = "Instalacion confirmada"
        }
    }

    if ($Action -eq "uninstall" -and $before -and -not $after) {
        return @{
            Success = $true
            Message = "Desinstalacion confirmada"
        }
    }

    return @{
        Success = $false
        Message = "No se pudo verificar el resultado"
    }
}

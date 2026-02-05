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
            # App load error - ignored for now
        }
    }
}

# ----------------------------------------
# Get app by Id
# ----------------------------------------
function Get-AppById {
    param (
        [string]$Id
    )

    return $Global:BK_Apps | Where-Object { $_.Id -eq $Id }
}

# ----------------------------------------
# Get apps by state
# ----------------------------------------
function Get-InstalledApps {
    return $Global:BK_Apps | Where-Object {
        $_.Detect -and (& $_.Detect)
    }
}

function Get-NotInstalledApps {
    return $Global:BK_Apps | Where-Object {
        $_.Detect -and (-not (& $_.Detect))
    }
}

# ----------------------------------------
# Execute app action
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

    try {
        & $App[$Action]

        return @{
            Success = $true
            Message = "Accion ejecutada"
        }
    }
    catch {
        return @{
            Success = $false
            Message = $_.Exception.Message
        }
    }
}

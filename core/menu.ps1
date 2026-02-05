# ========================================
# BK-Launcher V2 - Menus
# ========================================

function Show-MultiSelectMenu {
    param (
        [array]$Apps,
        [string]$Title
    )

    if (-not $Apps -or $Apps.Count -eq 0) {
        Clear-Host
        Write-Host "--------------------------------" -ForegroundColor $Color_Title
        Write-Host "   $Title"                       -ForegroundColor $Color_Title
        Write-Host "--------------------------------" -ForegroundColor $Color_Title
        Write-Host ""
        Write-Host "No hay aplicaciones definidas." -ForegroundColor $Color_Info
        Write-Host ""
        Read-Host "Pulsa ENTER para volver"
        return @()
    }

    $selected = @{}
    foreach ($app in $Apps) {
        $selected[$app.Id] = $false
    }

    while ($true) {
        Clear-Host

        Write-Host "--------------------------------" -ForegroundColor $Color_Title
        Write-Host "   $Title"                       -ForegroundColor $Color_Title
        Write-Host "--------------------------------" -ForegroundColor $Color_Title
        Write-Host ""

        $index = 1
        foreach ($app in $Apps) {
            $isInstalled = $false
            if ($app.Detect) { $isInstalled = & $app.Detect }

            $mark   = if ($selected[$app.Id]) { "[X]" } else { "[ ]" }
            $status = if ($isInstalled) { "INSTALADA" } else { "NO INSTALADA" }
            $color  = if ($isInstalled) { $Color_Error } else { $Color_Success }

            Write-Host "$mark $index - $($app.Name) [$status]" -ForegroundColor $color
            $index++
        }

        Write-Host ""
        Write-Host "Pulsa el numero para alternar seleccion" -ForegroundColor $Color_Info
        Write-Host "ENTER para continuar"                    -ForegroundColor $Color_Info
        Write-Host "0 para cancelar"                         -ForegroundColor $Color_Info
        Write-Host ""

        $input = Read-Host "Seleccion"

        if ($input -eq "0") { return @() }
        if ([string]::IsNullOrWhiteSpace($input)) { break }

        if ($input -match '^\d+$') {
            $choice = [int]$input
            if ($choice -ge 1 -and $choice -le $Apps.Count) {
                $app = $Apps[$choice - 1]
                $selected[$app.Id] = -not $selected[$app.Id]
            }
        }
    }

    return $Apps | Where-Object { $selected[$_.Id] }
}

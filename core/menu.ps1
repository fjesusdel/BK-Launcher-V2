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

    # Separar apps BK (tools propias)
    $bkApps = $Apps | Where-Object { $_.Id -in @("radial", "volume") }
    $otherApps = $Apps | Where-Object { $_.Id -notin @("radial", "volume") }

    $orderedApps = @()
    if ($bkApps.Count -gt 0) {
        $orderedApps += $bkApps
    }
    if ($otherApps.Count -gt 0) {
        $orderedApps += $otherApps
    }

    $selected = @{}
    foreach ($app in $orderedApps) {
        $selected[$app.Id] = $false
    }

    while ($true) {
        Clear-Host

        Write-Host "--------------------------------" -ForegroundColor $Color_Title
        Write-Host "   $Title"                       -ForegroundColor $Color_Title
        Write-Host "--------------------------------" -ForegroundColor $Color_Title
        Write-Host ""

        $index = 1

        if ($bkApps.Count -gt 0) {
            Write-Host "==============================" -ForegroundColor $Color_Info
            Write-Host "   BK LAUNCHER - TOOLS"        -ForegroundColor $Color_Info
            Write-Host "==============================" -ForegroundColor $Color_Info
            Write-Host ""
        }

        foreach ($app in $orderedApps) {

            if ($index -eq ($bkApps.Count + 1) -and $bkApps.Count -gt 0) {
                Write-Host ""
                Write-Host "==============================" -ForegroundColor $Color_Info
                Write-Host "        APLICACIONES"         -ForegroundColor $Color_Info
                Write-Host "==============================" -ForegroundColor $Color_Info
                Write-Host ""
            }

            $isInstalled = $false
            if ($app.Detect) { $isInstalled = & $app.Detect }

            $mark   = if ($selected[$app.Id]) { "[X]" } else { "[ ]" }
            $status = if ($isInstalled) { "INSTALADA" } else { "NO INSTALADA" }

            # Colores: sin rojo
            $color = if ($isInstalled) { $Color_Title } else { $Color_Info }

            $line = "{0} {1,2} - {2,-30} [{3}]" -f `
                $mark, $index, $app.Name, $status

            Write-Host $line -ForegroundColor $color

            # -------- DESCRIPCION SOLO SI ESTA SELECCIONADA --------
            if ($selected[$app.Id] -and $app.ContainsKey("Description")) {

                $descLines = $app.Description -split "`n"
                foreach ($descLine in $descLines) {
                    if (-not [string]::IsNullOrWhiteSpace($descLine)) {
                        Write-Host "      $descLine" -ForegroundColor DarkGray
                    }
                }
            }

            Write-Host ""
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
            if ($choice -ge 1 -and $choice -le $orderedApps.Count) {
                $app = $orderedApps[$choice - 1]
                $selected[$app.Id] = -not $selected[$app.Id]
            }
        }
    }

    return $orderedApps | Where-Object { $selected[$_.Id] }
}

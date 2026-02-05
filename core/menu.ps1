# ========================================
# BK-Launcher V2 - Menus
# ========================================

function Show-InstallMenu {
    param (
        [array]$Apps
    )

    Clear-Host

    Write-Host "--------------------------------" -ForegroundColor $Color_Title
    Write-Host "   INSTALAR APLICACIONES"         -ForegroundColor $Color_Title
    Write-Host "--------------------------------" -ForegroundColor $Color_Title
    Write-Host ""

    if (-not $Apps -or $Apps.Count -eq 0) {
        Write-Host "No hay aplicaciones para instalar." -ForegroundColor $Color_Info
        Write-Host ""
        Read-Host "Pulsa ENTER para volver"
        return
    }

    $index = 1
    foreach ($app in $Apps) {
        Write-Host "$index - $($app.Name)" -ForegroundColor $Color_Menu
        $index++
    }

    Write-Host ""
    Write-Host "0 - Volver" -ForegroundColor $Color_Menu
    Write-Host ""

    Read-Host "Pulsa ENTER para volver"
}

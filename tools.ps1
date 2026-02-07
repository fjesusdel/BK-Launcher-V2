# ========================================
# BK-Launcher V2 - Tools & Activations
# (AISLADO - SIN RECURSION)
# ========================================

function Show-ToolsMenu {

    while ($true) {

        Clear-Host

        Write-Host "==============================================="
        Write-Host "        HERRAMIENTAS Y ACTIVACIONES"
        Write-Host "==============================================="
        Write-Host ""
        Write-Host " 1 - Activacion de Windows y Office (Massgrave.dev)"
        Write-Host ""
        Write-Host " 0 - Volver"
        Write-Host ""

        $choice = Read-Host "Seleccion"

        switch ($choice) {

            "1" {
                Clear-Host

                Write-Host "-----------------------------------------------"
                Write-Host " ACTIVACION WINDOWS Y OFFICE (Massgrave.dev)"
                Write-Host "-----------------------------------------------"
                Write-Host ""
                Write-Host " Se va a abrir el menu de Massgrave en una nueva ventana."
                Write-Host " El launcher seguira funcionando con normalidad."
                Write-Host ""
                Write-Host " Cuando termines, vuelve aqui y pulsa ENTER."
                Write-Host ""

                Start-Process powershell `
                    -ArgumentList '-NoProfile -ExecutionPolicy Bypass -NoExit -Command "irm https://get.activated.win/ | iex"'

                Read-Host "Pulsa ENTER para volver al menu de herramientas"
            }

            "0" {
                return
            }

            default {
                continue
            }
        }
    }
}

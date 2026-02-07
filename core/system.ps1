# ========================================
# BK-Launcher V2 - System & About
# ========================================

# ----------------------------------------
# OBTENER INFORMACION DEL SISTEMA
# ----------------------------------------
function Get-SystemInfo {

    $os  = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1

    # CPU
    $cpuLoad = $cpu.LoadPercentage
    if ($cpuLoad -eq $null) { $cpuLoad = 0 }

    # RAM (GB)
    $totalRam = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $freeRam  = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    $usedRam  = [math]::Round($totalRam - $freeRam, 1)
    $ramUsage = if ($totalRam -gt 0) {
        [math]::Round(($usedRam / $totalRam) * 100, 1)
    } else { 0 }

    # DISCO C:
    $drive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $diskTotal = [math]::Round($drive.Size / 1GB, 1)
    $diskFree  = [math]::Round($drive.FreeSpace / 1GB, 1)
    $diskUsed  = [math]::Round($diskTotal - $diskFree, 1)
    $diskUsage = if ($diskTotal -gt 0) {
        [math]::Round(($diskUsed / $diskTotal) * 100, 1)
    } else { 0 }

    # RED
    $net = Get-CimInstance Win32_NetworkAdapterConfiguration |
        Where-Object { $_.IPAddress -and $_.DefaultIPGateway } |
        Select-Object -First 1

    $ipAddress = if ($net) { $net.IPAddress[0] } else { "No disponible" }
    $adapter   = if ($net) { $net.Description } else { "No disponible" }

    # Admin
    $isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    return @{
        OSName       = $os.Caption
        OSVersion    = $os.Version
        Architecture = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
        User         = $env:USERNAME
        Computer     = $env:COMPUTERNAME
        PowerShell   = $PSVersionTable.PSVersion.ToString()
        IsAdmin      = $isAdmin

        CPUName      = $cpu.Name.Trim()
        CPULoad      = $cpuLoad

        RAMTotal     = $totalRam
        RAMUsed      = $usedRam
        RAMFree      = $freeRam
        RAMUsage     = $ramUsage

        DiskTotal    = $diskTotal
        DiskUsed     = $diskUsed
        DiskFree     = $diskFree
        DiskUsage    = $diskUsage

        IPAddress    = $ipAddress
        Adapter      = $adapter
    }
}

# ----------------------------------------
# MOSTRAR INFORMACION DEL SISTEMA
# ----------------------------------------
function Show-SystemInfo {

    Clear-Host
    UI-Header
    UI-SectionTitle "INFORMACION DEL SISTEMA"

    $info = Get-SystemInfo

    Write-Host ""
    Write-Host " SISTEMA" -ForegroundColor Cyan
    Write-Host " -------------------------------------------"
    Write-Host " SO           : $($info.OSName)"
    Write-Host " Version      : $($info.OSVersion)"
    Write-Host " Arquitectura : $($info.Architecture)"
    Write-Host " Usuario      : $($info.User)"
    Write-Host " Equipo       : $($info.Computer)"
    Write-Host " PowerShell   : $($info.PowerShell)"
    Write-Host " Permisos     : " -NoNewline
    if ($info.IsAdmin) {
        Write-Host "Administrador" -ForegroundColor Green
    } else {
        Write-Host "No administrador" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host " CPU" -ForegroundColor Cyan
    Write-Host " -------------------------------------------"
    Write-Host " Modelo       : $($info.CPUName)"
    Write-Host " Uso actual   : $($info.CPULoad)%"

    Write-Host ""
    Write-Host " MEMORIA RAM" -ForegroundColor Cyan
    Write-Host " -------------------------------------------"
    Write-Host " Total        : $($info.RAMTotal) GB"
    Write-Host " En uso       : $($info.RAMUsed) GB"
    Write-Host " Libre        : $($info.RAMFree) GB"
    Write-Host " Uso          : $($info.RAMUsage)%"

    Write-Host ""
    Write-Host " DISCO (C:)" -ForegroundColor Cyan
    Write-Host " -------------------------------------------"
    Write-Host " Total        : $($info.DiskTotal) GB"
    Write-Host " En uso       : $($info.DiskUsed) GB"
    Write-Host " Libre        : $($info.DiskFree) GB"
    Write-Host " Uso          : $($info.DiskUsage)%"

    Write-Host ""
    Write-Host " RED" -ForegroundColor Cyan
    Write-Host " -------------------------------------------"
    Write-Host " Adaptador    : $($info.Adapter)"
    Write-Host " IP local     : $($info.IPAddress)"

    Write-Host ""
    Read-Host " Pulsa ENTER para volver al menu"
}

# ----------------------------------------
# ACERCA DE
# ----------------------------------------
function Show-About {

    Clear-Host
    UI-Header
    UI-SectionTitle "ACERCA DE"

    Write-Host ""
    Write-Host " BK-LAUNCHER V2" -ForegroundColor White
    Write-Host ""
    Write-Host " Sistema de gestion e instalacion de software" -ForegroundColor Gray
    Write-Host ""
    Write-Host " Autor   : Fran Delgado" -ForegroundColor Gray
    Write-Host " Version : 2.0" -ForegroundColor Gray
    Write-Host " Estado  : Estable" -ForegroundColor Green
    Write-Host ""
    Write-Host " Proyecto personal - entorno privado" -ForegroundColor DarkGray
    Write-Host ""

    Read-Host " Pulsa ENTER para volver al menu"
}

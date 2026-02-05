# ========================================
# BK-Launcher V2 - System Detection
# ========================================

function Get-SystemInfo {

    $os = Get-CimInstance Win32_OperatingSystem

    $isAdmin = ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ([Environment]::Is64BitOperatingSystem) {
        $architecture = "x64"
    } else {
        $architecture = "x86"
    }

    return @{
        OSName        = $os.Caption
        OSVersion     = $os.Version
        Architecture  = $architecture
        IsAdmin       = $isAdmin
        PowerShell    = $PSVersionTable.PSVersion.ToString()
    }
}

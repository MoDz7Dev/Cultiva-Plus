# ── Cultiva+ · Abre el puerto 8000 en el firewall de Windows ─────────
# Uso (desde la carpeta backend):   .\abrir-firewall.ps1
#
# Este script se auto-eleva: Windows te pedirá permiso (UAC) y luego crea
# una regla de entrada para el puerto TCP 8000.
#
# Sirve SOLO para desarrollo: permite que tu teléfono (misma Wi-Fi) llegue
# al backend que corre en esta PC. Para quitarla:
#   Remove-NetFirewallRule -DisplayName "Cultiva+ backend 8000"

$puerto = 8000
$nombre = "Cultiva+ backend $puerto"

$esAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $esAdmin) {
    Write-Host 'Se necesitan permisos de administrador. Abriendo UAC...' -ForegroundColor Yellow
    Start-Process powershell -Verb RunAs `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

Get-NetFirewallRule -DisplayName $nombre -ErrorAction SilentlyContinue |
    Remove-NetFirewallRule -ErrorAction SilentlyContinue

New-NetFirewallRule `
    -DisplayName $nombre `
    -Direction Inbound `
    -Protocol TCP `
    -LocalPort $puerto `
    -Action Allow `
    -Profile Any | Out-Null

Write-Host ""
Write-Host "  Listo: puerto $puerto abierto (regla '$nombre')." -ForegroundColor Green
Get-NetConnectionProfile | Select-Object InterfaceAlias, NetworkCategory | Format-Table -AutoSize
Write-Host "  Recuerda: el backend debe arrancarse con  .\run.ps1" -ForegroundColor Cyan
Write-Host ""

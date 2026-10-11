# ── Cultiva+ · Arranca el backend listo para el teléfono ─────────────
# Uso (desde la carpeta backend):   .\run.ps1
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

# Usa el entorno virtual si existe; si no, el python del sistema.
$python = Join-Path $PSScriptRoot '.venv\Scripts\python.exe'
if (-not (Test-Path $python)) { $python = 'python' }

# Muestra la IP de la red local (la que debe ir en ApiConfig.baseUrl).
$ip = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.InterfaceAlias -notmatch 'Loopback|Bluetooth|vEthernet' -and $_.IPAddress -notlike '169.254.*' } |
    Select-Object -First 1 -ExpandProperty IPAddress

Write-Host ''
Write-Host '  Cultiva+ · backend' -ForegroundColor Green
Write-Host '  Local .......... http://localhost:8000/health'
if ($ip) {
    Write-Host "  Teléfono ....... http://${ip}:8000/health" -ForegroundColor Cyan
    Write-Host "  -> Pon en lib/config/api_config.dart:  http://${ip}:8000" -ForegroundColor Cyan
}
Write-Host ''

& $python -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# ── Cultiva+ · Conecta el teléfono por USB (sin abrir el firewall) ────
# Uso (desde la carpeta backend):   .\usb.ps1
#
# Hace "adb reverse": el puerto 8000 del teléfono se redirige al puerto 8000
# de esta PC. Así la app puede usar http://localhost:8000 SIN tocar el
# firewall y SIN depender de la IP o de la Wi-Fi.
#
# Recuerda: en lib/config/api_config.dart
#   static const String baseUrl = 'http://localhost:8000';
#
# Hay que ejecutarlo cada vez que reconectes el teléfono.

$ErrorActionPreference = 'Stop'
$puerto = 8000

# 1) Buscamos adb: primero en el PATH, luego en las rutas típicas del SDK.
$adb = (Get-Command adb -ErrorAction SilentlyContinue).Source
if (-not $adb) {
    $candidatos = @(
        'D:\Android\sdk\platform-tools\adb.exe',
        (Join-Path $env:LOCALAPPDATA 'Android\Sdk\platform-tools\adb.exe'),
        (Join-Path $env:USERPROFILE 'AppData\Local\Android\Sdk\platform-tools\adb.exe')
    )
    $adb = $candidatos | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $adb) {
    Write-Host 'No encontré adb.exe. Instala las "platform-tools" del SDK de Android.' -ForegroundColor Red
    exit 1
}

Write-Host "Usando adb: $adb" -ForegroundColor DarkGray

# 2) ¿Hay algún dispositivo conectado?
$dispositivos = & $adb devices | Select-String -Pattern "`tdevice$"
if (-not $dispositivos) {
    Write-Host 'No hay ningún teléfono conectado. Activa la depuración USB y acepta el aviso en el teléfono.' -ForegroundColor Red
    & $adb devices
    exit 1
}

# 3) Redirigimos el puerto.
& $adb reverse "tcp:$puerto" "tcp:$puerto"

Write-Host ''
Write-Host "  Listo: tcp:$puerto del teléfono -> tcp:$puerto de la PC" -ForegroundColor Green
Write-Host '  En lib/config/api_config.dart usa:  http://localhost:8000' -ForegroundColor Cyan
Write-Host '  Redirecciones activas:' -ForegroundColor DarkGray
& $adb reverse --list
Write-Host ''

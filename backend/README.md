# Cultiva+ · Backend

API en FastAPI que identifica plantas con **Pl@ntNet** y completa la ficha con
**Trefle**. Las claves de las APIs viven solo aquí; la app Flutter nunca las ve.

## 1. Requisitos

- Python 3.11 o superior.

## 2. Instalación

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## 3. Configurar las claves

1. Copia el archivo de ejemplo:

   ```powershell
   copy .env.example .env
   ```

2. Edita `.env` y coloca tus claves:

   - `PLANTNET_API_KEY` → gratis en <https://my.plantnet.org/account>.
   - `TREFLE_TOKEN` → gratis en <https://trefle.io>.

> `.env` está ignorado por git: nunca se sube al repositorio.

## 4. Arrancar el servidor

```powershell
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

- Documentación interactiva: <http://localhost:8000/docs>
- Comprobación de estado: <http://localhost:8000/health>

`--host 0.0.0.0` es importante: permite que el teléfono se conecte por la red local.

## 5. Conectar la app Flutter

### Opción A (recomendada en desarrollo): USB con `adb reverse`

Conecta el teléfono por USB (depuración USB activada) y ejecuta:

```powershell
.\usb.ps1
```

(o el comando equivalente: `adb reverse tcp:8000 tcp:8000`)

Eso hace que `localhost:8000` **dentro del teléfono** apunte al puerto 8000 de
la PC. **No hace falta abrir el firewall ni estar en la misma Wi-Fi.**

En `lib/config/api_config.dart`:

```dart
static const String baseUrl = 'http://localhost:8000';
```

> `adb` viene con las *platform-tools* del SDK de Android. En esta PC está en
> `D:\Android\sdk\platform-tools\adb.exe` (no está en el PATH; `usb.ps1` ya
> lo busca solo).
> Hay que repetir el comando cada vez que reconectes el teléfono.

### Opción B: por Wi-Fi (requiere abrir el firewall)

En `lib/config/api_config.dart` ajusta `ApiConfig.baseUrl`:

| Dónde ejecutas la app | URL base |
| --- | --- |
| Teléfono físico (misma Wi-Fi) | `http://<IP_LAN_DE_TU_PC>:8000` |
| Emulador Android | `http://10.0.2.2:8000` |
| Simulador iOS / escritorio | `http://localhost:8000` |

Y abre el puerto 8000 en el firewall (ver **Solución de problemas**, punto 4).
Puedes hacerlo con el script incluido, que se auto-eleva:

```powershell
.\abrir-firewall.ps1
```

## 6. Endpoints

| Método | Ruta | Descripción |
| --- | --- | --- |
| `GET` | `/health` | Estado del servicio y de las claves. |
| `POST` | `/identify` | Multipart: `image` (archivo) + `organ` opcional. Devuelve las especies más probables. |
| `GET` | `/plants/{nombre}` | Ficha botánica de una especie por su nombre científico. |

## 7. Pruebas

```powershell
pytest
```

## 8. Atribución

- Identificación: **Pl@ntNet** (<https://plantnet.org>).
- Datos botánicos: **Trefle.io (CC-BY-4.0)** (<https://trefle.io>).

## 9. Solución de problemas

### «No se pudo analizar · No se pudo conectar con el backend»

La app no está alcanzando la PC. Revisa en este orden:

1. **¿Está encendido el servidor?** Debe mostrar `Uvicorn running on http://0.0.0.0:8000`.
   Si no aparece `0.0.0.0`, lo arrancaste mal: usa `--host 0.0.0.0`.
   Comprueba desde la PC:

   ```powershell
   Invoke-WebRequest http://localhost:8000/health -UseBasicParsing
   ```

2. **¿La IP es la correcta?** Ejecuta `ipconfig` en la PC y copia el `IPv4` del
   adaptador **Wi-Fi**. Ponlo en `lib/config/api_config.dart`:

   ```dart
   static const String baseUrl = 'http://192.168.0.10:8000';
   ```

3. **¿Están en la misma red?** El teléfono debe estar en la **misma Wi-Fi**
   (no en datos móviles). Prueba a abrir en el navegador del teléfono:

   ```
   http://192.168.0.10:8000/health
   ```

   Si eso no carga, es red/firewall, no la app.

4. **Firewall de Windows.** Tu red Wi-Fi suele estar como **Pública**, y en ese
   perfil Windows bloquea las conexiones entrantes. Abre el puerto 8000 con el
   script incluido (se auto-eleva y te pide permiso con UAC):

   ```powershell
   .\abrir-firewall.ps1
   ```

   O manualmente (PowerShell **como administrador**):

   ```powershell
   New-NetFirewallRule -DisplayName "Cultiva+ backend 8000" -Direction Inbound `
     -Protocol TCP -LocalPort 8000 -Action Allow -Profile Any
   ```

   **Alternativa que NO necesita firewall:** usa el USB con `adb reverse`
   (ver punto 5, Opción A).

   Alternativa (más segura): cambia la red Wi-Fi a **Privada** en
   Configuración → Red e Internet → Wi-Fi → Tipo de perfil de red, y usa
   `-Profile Private` en el comando de arriba.

   Comprueba que quedó creada:

   ```powershell
   Get-NetFirewallRule -DisplayName "Cultiva+ backend 8000"
   ```

   Y que tu red está en el perfil esperado:

   ```powershell
   Get-NetConnectionProfile | Select-Object InterfaceAlias, NetworkCategory
   ```

5. **¿Cambió tu IP?** El router la asigna por DHCP. Si cambia, repite el paso 2.

### «El análisis tardó demasiado»

El backend sí responde pero Pl@ntNet/la subida tardaron más de 90 s. Prueba con
una foto más cercana a la planta y con mejor luz, o revisa tu conexión a Internet.

### El backend arranca pero `/identify` devuelve 500

Falta una clave en `backend/.env`. Comprueba el estado:

```powershell
Invoke-WebRequest http://localhost:8000/health -UseBasicParsing
```

Debe responder `"plantnetConfigurado": true` y `"trefleConfigurado": true`.

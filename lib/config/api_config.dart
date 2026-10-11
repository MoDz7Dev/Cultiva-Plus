/// Configuración de acceso al backend de Cultiva+.
///
/// ── IMPORTANTE ───────────────────────────────────────────────────────
/// [baseUrl] debe apuntar a la PC donde corre la carpeta `backend/`.
///
///   • Teléfono físico (misma Wi-Fi) .. http://192.168.0.10:8000  ← tu PC
///   • Emulador Android .............. http://10.0.2.2:8000
///   • Simulador iOS / escritorio .... http://localhost:8000
///
/// Si tu IP cambia (el router la asigna por DHCP), ejecuta `ipconfig` en la
/// PC y actualiza [baseUrl].
///
/// El backend SIEMPRE debe arrancarse escuchando en toda la red:
///   uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
class ApiConfig {
  const ApiConfig._();

  /// URL base del backend (la PC donde corre FastAPI).
  static const String baseUrl = 'http://192.168.0.10:8000';

  /// Tiempo máximo para comprobar que el backend responde.
  static const Duration timeoutSalud = Duration(seconds: 6);

  /// Tiempo máximo para identificar la planta (Pl@ntNet puede tardar).
  static const Duration timeoutIdentificar = Duration(seconds: 90);

  /// Tiempo máximo para la ficha de Trefle.
  static const Duration timeoutDetalle = Duration(seconds: 30);
}

import 'package:cultiva_plus/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Tarjeta / botón de clima.
///
/// ⚠️ DISEÑO PROVISIONAL: todavía NO se conecta a ninguna API meteorológica.
/// Todos los datos llegan por parámetros para que, más adelante, se puedan
/// reemplazar por la respuesta real del servicio de meteorología del lugar
/// donde se encuentre el usuario.
///
/// Visualmente comparte el lenguaje de los botones de acción de la planta
/// (esquinas muy redondeadas e ícono + texto). Los colores salen de la paleta
/// de la app (app_theme.dart) y se derivan del verde primario [kPrimaryColor],
/// sin inventar tonos nuevos.
class WeatherCard extends StatelessWidget {
  /// Ubicación que se muestra en la cabecera (ej. "Tu ubicación", "CDMX").
  final String ubicacion;

  /// Temperatura principal (ej. "24°").
  final String temperatura;

  /// Descripción del estado del cielo (ej. "Parcialmente nublado").
  final String condicion;

  /// Humedad relativa (ej. "65%").
  final String humedad;

  /// Velocidad del viento (ej. "12 km/h").
  final String viento;

  /// Sensación térmica (ej. "26°").
  final String sensacion;

  /// Ícono del estado del tiempo.
  final IconData icono;

  /// Acción al tocar la tarjeta (más adelante: abrir el detalle del clima).
  final VoidCallback? onTap;

  const WeatherCard({
    super.key,
    this.ubicacion = 'Tu ubicación',
    this.temperatura = '24°',
    this.condicion = 'Parcialmente nublado',
    this.humedad = '65%',
    this.viento = '12 km/h',
    this.sensacion = '26°',
    this.icono = Icons.wb_cloudy_rounded,
    this.onTap,
  });

  // Paleta tomada de app_theme.dart. No se inventan colores nuevos:
  // el degradado y la sombra se derivan del verde primario de la app.
  static final Color _verdeClaro =
      Color.lerp(kPrimaryColor, Colors.white, 0.20)!;
  static final Color _verdeOscuro =
      Color.lerp(kPrimaryColor, Colors.black, 0.10)!;
  static final Color _sombra = kPrimaryColor.withValues(alpha: 0.30);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_verdeClaro, _verdeOscuro],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _sombra,
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Cabecera: ícono + ubicación/estado + temperatura ───
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icono, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ubicacion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            condicion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      temperatura,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                const SizedBox(height: 14),
                // ─── Datos secundarios del clima ───
                Row(
                  children: [
                    Expanded(
                      child: _DatoClima(
                        icono: Icons.water_drop_rounded,
                        valor: humedad,
                        etiqueta: 'Humedad',
                      ),
                    ),
                    const _Separador(),
                    Expanded(
                      child: _DatoClima(
                        icono: Icons.air_rounded,
                        valor: viento,
                        etiqueta: 'Viento',
                      ),
                    ),
                    const _Separador(),
                    Expanded(
                      child: _DatoClima(
                        icono: Icons.thermostat_rounded,
                        valor: sensacion,
                        etiqueta: 'Sensación',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Columna con un dato secundario del clima.
class _DatoClima extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;

  const _DatoClima({
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: Colors.white.withValues(alpha: 0.9), size: 18),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          etiqueta,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/// Separador vertical fino entre los datos del clima.
class _Separador extends StatelessWidget {
  const _Separador();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }
}

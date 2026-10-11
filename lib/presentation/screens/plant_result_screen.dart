import 'dart:io';

import 'package:cultiva_plus/config/theme/app_theme.dart';
import 'package:cultiva_plus/data/models/plant_identification.dart';
import 'package:flutter/material.dart';

/// Pantalla que muestra el resultado de una identificación.
///
/// Se abre desde `ScanScreen` cuando el backend ya respondió con la especie
/// (Pl@ntNet) y, si existe, con su ficha botánica (Trefle).
class PlantResultScreen extends StatelessWidget {
  const PlantResultScreen({
    super.key,
    required this.fotoPath,
    required this.identificacion,
    this.detalle,
  });

  /// Ruta local de la foto que se acaba de escanear.
  final String fotoPath;

  /// Resultado de Pl@ntNet (a través del backend).
  final IdentificacionPlanta identificacion;

  /// Ficha de Trefle (puede ser null si la especie no está en su catálogo).
  final DetallePlanta? detalle;

  // ── Paleta de marca ──
  static const Color _verde = Color(0xFF21955D);
  static const Color _texto = Color(0xFF1E1E1E);
  static const Color _textoSuave = Color(0xFF7A7A7A);
  static const Color _fondoSuave = Color(0xFFF0F5F0);
  static const Color _ambar = Color(0xFFE0A008); // coincidencia media
  static const Color _rojo = Color(0xFFD34B4B); // coincidencia baja

  /// Color de la insignia según la confianza:
  ///   ≥ 55 % verde · ≥ 25 % ámbar · por debajo rojo.
  static Color _colorCoincidencia(int porcentaje) {
    if (porcentaje >= 55) return _verde;
    if (porcentaje >= 25) return _ambar;
    return _rojo;
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final mejor = identificacion.mejor;
    final nombreComun = _primerNoVacio([
      detalle?.nombreComun,
      mejor?.nombreComun,
    ], 'Planta identificada');
    final nombreCientifico =
        detalle?.nombreCientifico ?? mejor?.nombreCientifico ?? '—';

    return Scaffold(
      // Blanco para que, al desplazar, no se vea el fondo gris detrás de la
      // tarjeta (que va desplazada 28 px hacia arriba para solaparse).
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _cabecera(context, topInset, mejor?.porcentaje),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -28, 0),
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20 + bottomInset),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titulo(nombreComun, nombreCientifico),
                  const SizedBox(height: 20),
                  _etiquetas(),
                  const SizedBox(height: 22),
                  _resumen(nombreComun),
                  if (identificacion.alternativas.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _otrasCoincidencias(),
                  ],
                  const SizedBox(height: 28),
                  _botones(),
                  const SizedBox(height: 18),
                  _atribucion(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Devuelve el primer valor no vacío de la lista o [porDefecto].
  String _primerNoVacio(List<String?> valores, String porDefecto) {
    for (final valor in valores) {
      if (valor != null && valor.trim().isNotEmpty) return valor;
    }
    return porDefecto;
  }

  // ─── Cabecera con la foto capturada ────────────────────────────────
  Widget _cabecera(BuildContext context, double topInset, int? porcentaje) {
    return SizedBox(
      height: 320 + topInset,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Foto que se acaba de escanear.
          Image.file(
            File(fotoPath),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: Color(0xFFDCEDC8),
              child: Center(
                child: Icon(
                  Icons.local_florist,
                  size: 90,
                  color: Color(0xFF7CC47C),
                ),
              ),
            ),
          ),
          // Degradado para que los controles se lean bien.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x00000000),
                  Color(0x33000000),
                ],
                stops: [0, 0.45, 1],
              ),
            ),
          ),
          // Botón de volver.
          Positioned(
            top: topInset + 8,
            left: 12,
            child: _botonCircular(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          // Chip con el % de coincidencia.
          if (porcentaje != null)
            Positioned(
              top: topInset + 12,
              right: 16,
              child: _chipCoincidencia(porcentaje),
            ),
        ],
      ),
    );
  }

  Widget _botonCircular({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: _texto),
        ),
      ),
    );
  }

  Widget _chipCoincidencia(int porcentaje) {
    final color = _colorCoincidencia(porcentaje);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            '$porcentaje% de coincidencia',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Nombre común y científico ─────────────────────────────────────
  Widget _titulo(String nombreComun, String nombreCientifico) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nombreComun,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: _texto,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          nombreCientifico,
          style: const TextStyle(
            fontSize: 16,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }

  // ─── Tarjetas: familia / género / año (con icono a la izquierda) ───
  Widget _etiquetas() {
    final familia = detalle?.familia ?? identificacion.mejor?.familia;
    final genero = detalle?.genero ?? identificacion.mejor?.genero;
    final anio = detalle?.anio;

    final etiquetas = <Widget>[
      if (familia != null && familia.isNotEmpty)
        _etiqueta(Icons.eco_outlined, 'Familia', familia),
      if (genero != null && genero.isNotEmpty)
        _etiqueta(Icons.local_florist_outlined, 'Género', genero),
      if (anio != null)
        _etiqueta(Icons.calendar_month_outlined, 'Año', '$anio'),
    ];

    if (etiquetas.isEmpty) return const SizedBox.shrink();

    // Se reparten a lo ancho de la pantalla para que no queden pegadas a la
    // izquierda (antes iban con Wrap y se agolpaban en el borde).
    return Row(
      spacing: 10,
      children: [for (final etiqueta in etiquetas) Expanded(child: etiqueta)],
    );
  }

  /// Tarjeta pequeña con el icono a la izquierda (estilo de la referencia).
  Widget _etiqueta(IconData icono, String titulo, String valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _fondoSuave,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icono, size: 20, color: _verde),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: _textoSuave,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _texto,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Datos (luz/humedad) + resumen ─────────────────────────────────
  Widget _resumen(String nombreComun) {
    final luz = detalle?.luz;
    final humedad = detalle?.humedad;
    final texto = (detalle?.resumen?.isNotEmpty ?? false)
        ? detalle!.resumen!
        : 'Aún no tenemos una ficha detallada de $nombreComun. '
            'Puedes aceptarla para guardarla en tu jardín.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (luz != null || humedad != null) ...[
          Row(
            children: [
              if (luz != null)
                Expanded(
                  child: _datoIcono(
                    Icons.wb_sunny_outlined,
                    'Luz',
                    luz,
                    Colors.orange,
                  ),
                ),
              if (luz != null && humedad != null) const SizedBox(width: 12),
              if (humedad != null)
                Expanded(
                  child: _datoIcono(
                    Icons.water_drop_outlined,
                    'Humedad',
                    humedad,
                    Colors.blue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
        const Text(
          'Resumen',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _texto,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Color(0xFF5A5A5A),
          ),
        ),
      ],
    );
  }

  Widget _datoIcono(IconData icono, String titulo, String valor, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _fondoSuave,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icono, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _textoSuave,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  valor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _texto,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Otras especies candidatas ─────────────────────────────────────
  Widget _otrasCoincidencias() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Otras coincidencias',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _texto,
          ),
        ),
        const SizedBox(height: 8),
        ...identificacion.alternativas.take(4).map(
          (c) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.eco_outlined,
                  size: 18,
                  color: Color(0xFF7CC47C),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c.nombreCientifico,
                    style: const TextStyle(fontSize: 14, color: _texto),
                  ),
                ),
                Text(
                  '${c.porcentaje}%',
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textoSuave,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Botones (por ahora no hacen nada) ─────────────────────────────
  Widget _botones() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton(
              // TODO: pendiente -> volver a la cámara para escanear de nuevo.
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _verde,
                side: const BorderSide(color: _verde, width: 1.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Volver a escanear',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              // TODO: pendiente -> guardar la planta en el jardín del usuario.
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _verde,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Aceptar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Atribución obligatoria de las APIs ────────────────────────────
  Widget _atribucion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Identificación: ${identificacion.fuente}.',
          style: const TextStyle(fontSize: 11, color: _textoSuave),
        ),
        if (detalle != null)
          const Text(
            'Datos botánicos: Trefle.io (CC-BY-4.0).',
            style: TextStyle(fontSize: 11, color: _textoSuave),
          ),
      ],
    );
  }
}

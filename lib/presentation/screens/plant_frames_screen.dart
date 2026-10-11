import 'package:cultiva_plus/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

// ─── Paleta local del diseño ──────────────────────────────────────
const Color _kVerde = Color(0xFF21955D); // acento de marca
const Color _kVerdeLima = Color(0xFFB4E051); // campana de notificaciones
const Color _kVerdeHoja = Color(0xFF7CC47C); // insignia de hoja
const Color _kFondoHero = Color(0xFFE4EDE4); // fondo de la tarjeta destacada
const Color _kFondoSuave = Color(0xFFF0F5F0); // círculos y placeholders
const Color _kTexto = Color(0xFF1E1E1E);
const Color _kTextoSecundario = Color(0xFF8A8A8A);

// Imagen remota del avatar (mismo patrón que info_plant.dart / plant_header.dart).
const String _kAvatarUrl =
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80&auto=format&fit=crop';

// Recorte de planta con fondo transparente (asset local) usado en la
// tarjeta destacada para que sobresalga de la tarjeta.
const String _kPlantaRecorte = 'assets/images/plantita.png';

/// Modelo de una variante de planta del catálogo.
class _Variante {
  final String nombre;
  final String precio;
  final String imagen;
  final IconData icono;

  const _Variante({
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.icono,
  });
}

const List<_Variante> _variantes = [
  _Variante(
    nombre: 'Monstera Plant',
    precio: '\$150',
    imagen:
        'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400&q=80&auto=format&fit=crop',
    icono: Icons.wb_sunny_outlined,
  ),
  _Variante(
    nombre: 'Zamioculcas Plant',
    precio: '\$120',
    imagen:
        'https://images.unsplash.com/photo-1632207691143-643e2a9a9361?w=400&q=80&auto=format&fit=crop',
    icono: Icons.water_drop_outlined,
  ),
  _Variante(
    nombre: 'Philodendron',
    precio: '\$105',
    imagen:
        'https://images.unsplash.com/photo-1611211232932-da3113c5b960?w=400&q=80&auto=format&fit=crop',
    icono: Icons.wb_sunny_outlined,
  ),
  _Variante(
    nombre: 'Pothos Plant',
    precio: '\$50',
    imagen:
        'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?w=400&q=80&auto=format&fit=crop',
    icono: Icons.water_drop_outlined,
  ),
];

/// Pantalla con el marco/catálogo de plantas.
///
/// Réplica del diseño de referencia (cabecera, buscador, tarjeta destacada y
/// grid "Variants"), SIN la barra inferior flotante.
class PlantFramesScreen extends StatelessWidget {
  const PlantFramesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Cabecera(),
              const SizedBox(height: 20),
              const _BarraBusqueda(),
              const SizedBox(height: 22),
              const _TarjetaDestacada(),
              const SizedBox(height: 26),
              const Text(
                'Variants',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _kTexto,
                ),
              ),
              const SizedBox(height: 16),
              _construirGridVariantes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirGridVariantes() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _variantes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 186,
      ),
      itemBuilder: (context, index) =>
          _TarjetaVariante(variante: _variantes[index]),
    );
  }
}

// ─── Cabecera: avatar + saludo + acciones ─────────────────────────
class _Cabecera extends StatelessWidget {
  const _Cabecera();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            _kAvatarUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 48,
              height: 48,
              color: _kFondoSuave,
              child: const Icon(Icons.person, color: _kVerde),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome Back👋',
                style: TextStyle(fontSize: 13, color: _kTextoSecundario),
              ),
              SizedBox(height: 2),
              Text(
                'Brooklyn Simmons',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _kTexto,
                ),
              ),
            ],
          ),
        ),
        const _BotonCampana(),
        const SizedBox(width: 10),
        const _BotonClima(),
      ],
    );
  }
}

// ─── Botón de notificaciones (campana con punto rojo) ─────────────
class _BotonCampana extends StatelessWidget {
  const _BotonCampana();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: _kVerdeLima,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications, color: _kVerde, size: 24),
        ),
        Positioned(
          top: 2,
          right: 4,
          child: Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: const Color(0xFFE53935),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Botón de clima (sol) ─────────────────────────────────────────
class _BotonClima extends StatelessWidget {
  const _BotonClima();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.wb_sunny_outlined, color: _kVerde, size: 24),
    );
  }
}

// ─── Barra de búsqueda + botón de filtros ─────────────────────────
class _BarraBusqueda extends StatelessWidget {
  const _BarraBusqueda();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(27),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: _kTextoSecundario, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: _kTextoSecundario,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.tune, color: _kTexto, size: 22),
        ),
      ],
    );
  }
}

// ─── Tarjeta destacada (suculenta) ────────────────────────────────
class _TarjetaDestacada extends StatelessWidget {
  const _TarjetaDestacada();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 224,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kFondoHero,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Información de la planta (lado derecho)
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(215, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Succulent',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _kTexto,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "12 day's ago planted",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: _kTextoSecundario),
                  ),
                  SizedBox(height: 12),
                  _PildoraDato(
                    icono: Icons.thermostat,
                    colorIcono: _kVerde,
                    titulo: 'Room temp',
                    valor: '24°C',
                  ),
                  SizedBox(height: 8),
                  _PildoraDato(
                    icono: Icons.lightbulb_outline,
                    colorIcono: Color(0xFFF5B301),
                    titulo: 'Room Light',
                    valor: '17%',
                    relleno: false,
                  ),
                ],
              ),
            ),
          ),
          // Recorte de la planta (fondo transparente) que sobresale de la
          // tarjeta por arriba y por la izquierda.
          Positioned(
            left: 6,
            top: -20,
            child: SizedBox(
              width: 184,
              height: 252,
              child: Image.asset(
                _kPlantaRecorte,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                cacheWidth: 550,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Píldora con icono + dato (usada en la tarjeta destacada) ─────
class _PildoraDato extends StatelessWidget {
  final IconData icono;
  final Color colorIcono;
  final String titulo;
  final String valor;

  /// `true`  → círculo relleno del color + ícono blanco.
  /// `false` → círculo tenue del color + ícono de color.
  final bool relleno;

  const _PildoraDato({
    required this.icono,
    required this.colorIcono,
    required this.titulo,
    required this.valor,
    this.relleno = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: relleno ? colorIcono : colorIcono.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icono,
              color: relleno ? Colors.white : colorIcono,
              size: 15,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color: _kTextoSecundario,
                  ),
                ),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _kTexto,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tarjeta de una variante del grid ─────────────────────────────
class _TarjetaVariante extends StatelessWidget {
  final _Variante variante;

  const _TarjetaVariante({required this.variante});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: _kFondoSuave,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(variante.icono, size: 19, color: _kTexto),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        variante.imagen,
                        height: 84,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          height: 84,
                          color: _kFondoSuave,
                          child: const Icon(
                            Icons.local_florist,
                            color: _kVerde,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                variante.nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _kTexto,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                variante.precio,
                style: const TextStyle(
                  fontSize: 13,
                  color: _kTextoSecundario,
                ),
              ),
            ],
          ),
        ),
        // Insignia de hoja: pegada a la esquina inferior derecha de la
        // tarjeta, con la esquina superior izquierda redondeada.
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: _kVerdeHoja,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Icon(
              Icons.eco_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}
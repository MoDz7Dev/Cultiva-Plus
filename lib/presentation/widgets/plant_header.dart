import 'package:flutter/material.dart';

class PlantHeader extends StatelessWidget {
  final String plantImage;

  const PlantHeader({
    super.key,
    required this.plantImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // Para que ocupe todo el espacio del SliverAppBar
      children: [
        // Fondo con degradado blanco verdoso
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF1F8E9), Color(0xFFDCEDC8)],
            ),
          ),
        ),

        // Botones superiores (Estrella y Cámara)
        Positioned(
          top: 60, // Ajustado para que no choque con el botón de atrás
          right: 20,
          child: Column(
            children: [
              Icon(Icons.favorite, color: const Color.fromARGB(255, 255, 20, 20), size: 32),
              const SizedBox(height: 10),
              Icon(Icons.camera_alt_outlined, color: Colors.grey[800], size: 28),
            ],
          ),
        ),

        // Imagen de la planta
        Positioned(
          bottom: 0, // Alineado al fondo del header
          left: 0,
          right: 0,
          child: Image.network(
            plantImage,
            height: 260, // Un poco más grande para que se aprecie el detalle
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => 
                Icon(Icons.eco, size: 150, color: Colors.green[300]),
          ),
        ),
      ],
    );
  }
}
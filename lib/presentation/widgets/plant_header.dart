import 'package:flutter/material.dart';

class PlantHeader extends StatelessWidget {
  final String plantImage;
  final VoidCallback? onBackPressed;

  const PlantHeader({
    super.key,
    required this.plantImage,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Fondo con degradado blanco verdoso
        Container(
          height: 320,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF1F8E9), Color(0xFFDCEDC8)], // Blanco a verde claro
            ),
          ),
        ),

        // Botones superiores (Estrella y Cámara)
        Positioned(
          top: 50,
          right: 20,
          child: Column(
            children: [
              Icon(Icons.star, color: Colors.amber[700], size: 32),
              const SizedBox(height: 10),
              Icon(Icons.camera_alt_outlined, color: Colors.grey[800], size: 28),
            ],
          ),
        ),

        // Botón de regresar
        Positioned(
          top: 50,
          left: 20,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[800]),
            onPressed: onBackPressed ?? () => Navigator.pop(context),
          ),
        ),

        // Imagen de la planta (ajustada para que no se corte al hacer scroll)
        Positioned(
          bottom: -40, 
          child: Image.network(
            plantImage,
            height: 240,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => 
                Icon(Icons.eco, size: 150, color: Colors.green[300]),
          ),
        ),
      ],
    );
  }
}
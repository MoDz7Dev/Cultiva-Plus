import 'package:flutter/material.dart';
import '../widgets/plant_header.dart';
import '../widgets/plant_stats_card.dart';

class InfoPlant extends StatelessWidget {
  const InfoPlant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9), // Fondo general blanco verdoso
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Cabecera con la imagen (sin nivel)
            const PlantHeader(
              plantImage: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?q=80&w=1000&auto=format&fit=crop',
            ),
            
            // 2. Tarjeta blanca con estadísticas y acciones
            const PlantStatsCard(
              plantName: 'Monstera Deliciosa',
              currentHp: '66',
              maxHp: '66',
              light: 'Indirecta', // Antes era weight
              profile: 'Araceae', // Antes era type
              height: '0.64m',
              summary: 'Monstera Deliciosa, also known as the Swiss Cheese Plant, is a species of flowering plant native to tropical forests. It is famous for its natural leaf holes and is very easy to care for indoors.',
            ),
          ],
        ),
      ),
    );
  }
}
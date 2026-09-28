import 'package:flutter/material.dart';
import '../widgets/plant_header.dart';
import '../widgets/plant_stats_card.dart';
import '../widgets/button_common.dart'; // Importa tu botón personalizado

class InfoPlant extends StatelessWidget {
  const InfoPlant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: CustomScrollView(
        // Física de scroll para que se sienta fluido en iOS y Android
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 380.0, // Altura cuando está expandido
            pinned: true, // Se queda fijo arriba al hacer scroll hacia abajo
            stretch: true, // Permite estirar al hacer overscroll
            backgroundColor: const Color(0xFFF1F8E9), // Color de fondo al colapsar
            elevation: 0,
            // Botón de regresar personalizado en la barra de la app
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: CustomButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              // ESTO HACE LA MAGIA: Zoom en el fondo al arrastrar hacia abajo
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: const PlantHeader(
                plantImage: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?q=80&w=1000&auto=format&fit=crop',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const PlantStatsCard(
              plantName: 'Monstera Deliciosa',
              actualLVL: '66', // Variables actualizadas
              maxLVL: '66',    // Variables actualizadas
              light: 'Indirecta',
              profile: 'Araceae',
              height: '0.64m',
              summary: 'Monstera Deliciosa, also known as the Swiss Cheese Plant, is a species of flowering plant native to tropical forests. It is famous for its natural leaf holes and is very easy to care for indoors.',
            ),
          ),
        ],
      ),
    );
  }
}
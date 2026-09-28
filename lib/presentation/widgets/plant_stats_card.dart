import 'package:flutter/material.dart';
import 'plant_action_button.dart';

class PlantStatsCard extends StatelessWidget {
  final String plantName;
  final String actualLVL; // Actualizado
  final String maxLVL;    // Actualizado
  final String light;
  final String height;
  final String profile;
  final String summary;

  const PlantStatsCard({
    super.key,
    required this.plantName,
    required this.actualLVL,
    required this.maxLVL,
    required this.light,
    required this.height,
    required this.profile,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Quitamos el transform para que fluya natural con el scroll
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Nombre y Editar ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  plantName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.edit, size: 18, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 10),

            // --- Barra de LVL ---
            Center(
              child: Column(
                children: [
                  Container(
                    height: 8,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$actualLVL / $maxLVL LVL', // Texto actualizado
                    style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Fila de Estadísticas (Luz, Perfil, Altura) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(light, 'LUZ', Icons.wb_sunny_outlined, color: Colors.orange),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                _buildStatItem(profile, 'PERFIL', Icons.eco, color: Colors.green),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                _buildStatItem(height, 'ALTURA', Icons.height),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // --- Botones de Acción ---
            PlantActionButton(
              title: 'REGAR',
              icon: Icons.water_drop,
              cost1: '1,921',
              cost2: '3',
              backgroundColor: const Color(0xFFE8F5E9),
              textColor: const Color(0xFF2E7D32),
              onTap: () {},
            ),
            PlantActionButton(
              title: 'FERTILIZAR',
              icon: Icons.eco,
              cost1: '3,000',
              cost2: '3',
              backgroundColor: const Color(0xFFFCE4EC),
              textColor: const Color(0xFFC2185B),
              onTap: () {},
            ),
            PlantActionButton(
              title: 'PODAR',
              icon: Icons.content_cut,
              cost1: '25',
              cost2: '0',
              backgroundColor: const Color(0xFFF5F5F5),
              textColor: const Color(0xFF616161),
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // --- Resumen ---
            const Text(
              'Resumen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              summary,
              style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.grey[700], size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
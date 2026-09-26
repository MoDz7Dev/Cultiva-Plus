import 'package:cultiva_plus/presentation/screens/planta_detail_screen.dart';
import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Escanear planta')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.photo_camera, size: 96, color: Color(0xFF49149F)),
              const SizedBox(height: 24),
              const Text(
                'Aquí irá la cámara para fotografiar tu planta.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '(Por ahora usamos datos de ejemplo, sin IA ni API)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlantaDetailScreen()),
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('Identificar (ejemplo)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
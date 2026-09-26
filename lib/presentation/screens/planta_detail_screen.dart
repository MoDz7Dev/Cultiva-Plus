import 'package:flutter/material.dart';

class PlantaDetailScreen extends StatelessWidget {
  const PlantaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Detalle de la planta')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.local_florist, size: 80, color: Color(0xFF49149F)),
          const SizedBox(height: 8),
          const Text(
            'Maíz (Zea mays)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _DatoDuro(label: 'Especie', valor: 'Zea mays'),
          _DatoDuro(label: 'Reino', valor: 'Plantae'),
          _DatoDuro(label: 'Riego recomendado', valor: 'Cada 2-3 días'),
          _DatoDuro(label: 'Luz necesaria', valor: 'Pleno sol'),
          _DatoDuro(label: 'Ciclo de vida', valor: 'Anual'),
        ],
      ),
    );
  }
}

class _DatoDuro extends StatelessWidget {
  const _DatoDuro({this.label, this.valor});

  final String? label;
  final String? valor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(label ?? ''),
        subtitle: Text(valor ?? ''),
      ),
    );
  }
}
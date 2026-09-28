import 'package:flutter/material.dart';

class InfoPlant extends StatelessWidget {
  const InfoPlant({super.key});

  @override
  Widget build(BuildContext context) {
    // Al ser una Screen, retorna directamente el Scaffold
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Fondo gris claro
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // --- Botones superiores (Favorito, Guardar, Contactar) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildIconButton(Icons.favorite_border),
                    const SizedBox(width: 8),
                    _buildIconButton(Icons.bookmark_border),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Get in touch',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Tarjeta Principal ---
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen de la planta con botones superpuestos
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?q=80&w=1000&auto=format&fit=crop',
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Botón de regresar (Atrás)
                          Positioned(
                            top: 16,
                            left: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withValues(alpha: 0.3),
                              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                            ),
                          ),
                          // Botón de opciones (tres puntos)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withValues(alpha: 0.3),
                              child: const Icon(Icons.more_horiz, color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),

                      // Información de la planta
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre y Precio
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Monstera Deliciosa',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    '\$45',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Distancia
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  'Distance (Near 5km)',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Fila de detalles (Luz, Riego, Altura)
                            Row(
                              children: [
                                _buildDetailBox('Light', 'Indirect'),
                                const SizedBox(width: 10),
                                _buildDetailBox('Water', 'Weekly'),
                                const SizedBox(width: 10),
                                _buildDetailBox('Height', '60 cm'),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Perfil de la Planta
                            const Text(
                              'Plant Profile',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Color(0xFFE8F5E9), // Fondo verde claro
                                  child: Icon(Icons.eco, color: Colors.green), // Icono de hoja
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Araceae Family',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(Icons.public, size: 12, color: Colors.grey[500]),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Native to Central America',
                                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Icon(Icons.water_drop_outlined, color: Colors.grey[700]),
                                const SizedBox(width: 16),
                                Icon(Icons.wb_sunny_outlined, color: Colors.grey[700]),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Resumen / Descripción
                            const Text(
                              'Summary',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Monstera Deliciosa, also known as the Swiss Cheese Plant, is a species of flowering plant native to tropical forests. It is famous for its natural leaf holes and is very easy to care for indoors.',
                              style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para los botones redondos de arriba
  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Icon(icon, size: 20, color: Colors.black87),
    );
  }

  // Widget auxiliar para las cajas de Luz, Riego y Altura
  Widget _buildDetailBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class PlantActionButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String cost1;
  final String cost2;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const PlantActionButton({
    super.key,
    required this.title,
    this.icon,
    required this.cost1,
    required this.cost2,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 10),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                // Costo 1 (Ej: Luz Solar)
                _buildCostItem(Icons.wb_sunny_outlined, cost1, textColor),
                const SizedBox(width: 16),
                // Costo 2 (Ej: Agua)
                _buildCostItem(Icons.water_drop_outlined, cost2, textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
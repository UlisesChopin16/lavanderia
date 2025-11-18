import 'package:flutter/material.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/filtros/filtros_ordenes.dart';

class EstatusContainer extends StatelessWidget {
  final EstatusOrdenType estatus;
  const EstatusContainer({super.key, required this.estatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: estatus.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        spacing: 5,
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        children: [
          Icon(estatus.icon, color: estatus.color, size: 20),
          Text(
            estatus.value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: estatus.color,
            ),
          ),
        ],
      ),
    );
  }
}

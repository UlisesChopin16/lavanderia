import 'package:flutter/material.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';

class ItemServicio extends StatelessWidget {
  final VoidCallback? onDelete;
  final ItemConPrecioEntity item;
  final bool forTicket;
  const ItemServicio({
    super.key,
    required this.item,
    this.forTicket = false,
    this.onDelete,
  });

  static const double sizeIcon = 16.0;
  static const double textSize = 12.0;
  static const crossAxis = CrossAxisAlignment.center;
  static const minSize = MainAxisSize.min;
  static const mainAlignment = MainAxisAlignment.start;

  Color? get colorTicket => forTicket ? Colors.black : null;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: !forTicket
          ? const CircleAvatar(
              child: Icon(IconsManager.clotheIcon),
            )
          : null,
      title: Text(
        item.precio.nombreConcepto,
        style: TextStyle(
          color: colorTicket,
        ),
      ),
      subtitle: Wrap(
        spacing: 15,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.start,
        children: [
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                crossAxisAlignment: crossAxis,
                mainAxisSize: minSize,
                children: [
                  if (!forTicket) const Icon(IconsManager.selectedSizesIcon, size: sizeIcon),
                  Flexible(
                    child: Text(
                      item.precio.size.description,
                      style: TextStyle(fontSize: textSize, color: colorTicket),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                crossAxisAlignment: crossAxis,
                mainAxisSize: minSize,
                children: [
                  if (!forTicket) const Icon(IconsManager.selectedCategoriasIcon, size: sizeIcon),
                  Flexible(
                    child: Text(
                      item.precio.categoria.nombre,
                      style: TextStyle(fontSize: textSize, color: colorTicket),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                crossAxisAlignment: crossAxis,
                mainAxisSize: minSize,
                children: [
                  if (!forTicket) const Icon(IconsManager.selectedPreciosIcon, size: sizeIcon),
                  Flexible(
                    child: Text(
                      item.precio.importe.toStringAsFixed(2),
                      style: TextStyle(fontSize: textSize, color: colorTicket),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                crossAxisAlignment: crossAxis,
                mainAxisSize: minSize,
                children: [
                  if (!forTicket) const Icon(Icons.event, size: sizeIcon),
                  Flexible(
                    child: Text(
                      item.precio.daysText,
                      style: TextStyle(fontSize: textSize, color: colorTicket),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDelete,
            )
          : null,
    );
  }
}

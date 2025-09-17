import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';

class ChangeCantidad extends HookWidget {
  const ChangeCantidad({
    super.key,
    required this.cantidad,
    required this.unidad,
    this.onChanged,
    this.color,
  });

  final double cantidad;
  final ValueChanged<double>? onChanged;
  final UnitType unidad;
  final Color? color;

  bool get isKg => unidad == UnitType.kilo;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final backgroundColor = color ?? Theme.of(context).colorScheme.surfaceContainer;
    controller.text = isKg ? cantidad.toStringAsFixed(2) : cantidad.toStringAsFixed(0);
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Visibility(
          visible: cantidad > 1,
          child: InkWell(
            onTap: () {
              // Decrease quantity
              if (onChanged != null) onChanged!(cantidad - 1);
            },
            child: Card(
              margin: EdgeInsets.zero,
              // shape: const CircleBorder(),
              color: backgroundColor,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.remove),
              ),
            ),
          ),
        ),
        TextFormField(
          readOnly: !isKg,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),

          decoration: InputDecoration(
            labelText: unidad.value,
            constraints: const BoxConstraints(maxWidth: 70, maxHeight: 30),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            // prefixIcon: SizedBox(
            //   width: 10,
            //   child: Text(unidad.letters),
            // ),
            contentPadding: const EdgeInsets.only(
              top: 10,
              bottom: 8,
              left: 12,
              right: 12,
              // vertical: 8.0, horizontal: 12.0
            ),
          ),
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            // FilteringTextInputFormatter.deny(RegExp(r'^[^\d.]+$')),
          ],
          onChanged: (value) {
            final newCantidad = double.tryParse(value) ?? 1.0;
            if (onChanged != null && newCantidad > 0) {
              onChanged!(newCantidad);
            }
          },
        ),
        InkWell(
          onTap: () {
            // Increase quantity
            if (onChanged != null) onChanged!(cantidad + 1);
          },
          child: Card(
            margin: EdgeInsets.zero,
            // shape: const CircleBorder(),
            color: backgroundColor,
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}

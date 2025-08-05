import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';

class RadioColors extends ConsumerWidget {
  final double width;
  const RadioColors({super.key, required this.width});

  List<Color> get colors {
    const primaries = Colors.primaries;
    List<Color> colors = [];
    for (var i = 0; i < primaries.length; i++) {
      final colorP = primaries[i];
      final argb = colorP.toARGB32();
      final color = Color(argb);
      colors.add(color);
    }
    return colors;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final groupValue = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => value.configuracionEmpresa.colorParsed,
      ),
    );
    return SizedBox(
      width: width,
      child: Wrap(
        children: colors.map(
          (color) {
            return Radio(
              value: color,
              groupValue: groupValue,
              onChanged: (value) {
                if (value == null) return;
                configuracionNotifier.setColor(value);
              },
              activeColor: color,
              fillColor: WidgetStatePropertyAll(
                color,
              ),
              overlayColor: WidgetStatePropertyAll(
                color.withOpacity(0.2),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

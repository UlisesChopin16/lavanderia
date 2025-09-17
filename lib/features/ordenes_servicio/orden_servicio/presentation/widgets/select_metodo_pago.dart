import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/metodo_pago_type.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class SelectMetodoPago extends HookWidget {
  const SelectMetodoPago({
    super.key,
    required this.metodoPago,
    required this.onChange,
  });

  final MetodoPagoType? metodoPago;
  final ValueChanged<MetodoPagoType?> onChange;

  static const metodos = MetodoPagoType.values;

  bool get isEmpty => metodoPago == null;


  static const width = 200.0;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    controller.text = metodoPago?.value ?? '';

    return SizedBox(
      width: width,
      child: DropdownMenuBase<MetodoPagoType>(
        label: 'Metodos de pago',
        width: width,
        controller: controller,
        items: _dropdownItems(),
        showDelete: !isEmpty,
        onDelete: () => onChange(null),
        leadingIcon: const Icon(IconsManager.selectedSizesIcon),
        value: metodoPago,
        onChanged: onChange,
      ),
    );
  }
  
  List<DropdownMenuEntry<MetodoPagoType>> _dropdownItems() {
    return metodos.map((metodo) {
      return DropdownMenuEntry(
        value: metodo,
        label: metodo.value,
      );
    }).toList();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class SelectUnit extends HookWidget {
  final UnitType unitType;
  final ValueChanged<UnitType> onUnitChanged;

  const SelectUnit({
    super.key,
    required this.unitType,
    required this.onUnitChanged,
  });

  final units = UnitType.values;

  List<DropdownMenuEntry<UnitType>> get _dropdownItems {
    return units.map((unit) {
      return DropdownMenuEntry(
        value: unit,
        label: unit.value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    controller.text = unitType.value;

    return DropdownMenuBase<UnitType>(
      label: 'Tipo de unidad',
      width: 200,
      controller: controller,
      items: _dropdownItems,
      leadingIcon: const Icon(Icons.widgets_rounded),
      value: unitType,
      onChanged: (value) {
        onUnitChanged(value ?? UnitType.pieza);
      },
    );
  }
}

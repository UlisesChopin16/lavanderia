import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/presentation/types/column_names_type.dart';
import 'package:lavanderia/shared/widgets/dropdown_menu_base.dart';

class FiltroOrden extends HookWidget {
  final ColumnNamesType ordenamiento;
  final ValueChanged<ColumnNamesType> onOrdenamientoChanged;
  final ValueChanged<bool> onAscendenteChanged;
  final bool ascendente;

  const FiltroOrden({
    super.key,
    required this.ordenamiento,
    required this.onOrdenamientoChanged,
    required this.onAscendenteChanged,
    this.ascendente = true,
  });

  final columnNames = ColumnNamesType.values;

  List<DropdownMenuEntry<ColumnNamesType>> get _dropdownItems {
    return columnNames.map((column) {
      final isTheSame = column == ordenamiento;
      final leading = isTheSame ? leadingIcon : null;
      return DropdownMenuEntry(
        value: column,
        label: column.title,
        leadingIcon: leading,
      );
    }).toList();
  }

  Widget get leadingIcon {
    final sortedIcon = IconsManager.getSortIcon(ascendente);
    return IconButton(
      onPressed: () {
        onAscendenteChanged(!ascendente);
      },
      iconSize: 20,
      icon: Icon(sortedIcon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    controller.text = ordenamiento.title;

    return DropdownMenuBase<ColumnNamesType>(
      label: 'Ordenar por',
      leadingIcon: leadingIcon,
      controller: controller,
      items: _dropdownItems,
      value: ordenamiento,
      onChanged: (value) {
        onOrdenamientoChanged(value ?? ColumnNamesType.nombre);
      },
    );
  }
}

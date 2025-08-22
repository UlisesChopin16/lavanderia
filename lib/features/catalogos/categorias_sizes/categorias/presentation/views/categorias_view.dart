import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';
import 'package:lavanderia/shared/widgets/title_container.dart';

class CategoriasView extends ConsumerStatefulWidget {
  const CategoriasView({super.key});

  @override
  ConsumerState<CategoriasView> createState() => _CategoriasViewState();
}

class _CategoriasViewState extends ConsumerState<CategoriasView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        spacing: 15,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: TitleContainer(
              title: 'Categorias de ropa',
              icon: IconsManager.selectedCategoriasIcon,
            ),
          ),
          TableCardInfo(
            smallView: const SizedBox(),
            titleAddButton: 'Agregar categoría de ropa',
            onAddButtonPressed: () {
              // Acción al presionar el botón de agregar categoría
              Printer.d('Agregar Categoría presionado');
            },
            onSearchChanged: (value) {
              // Acción al cambiar el texto de búsqueda
              Printer.d('Buscar: $value');
            },
            columns: [
              const DataColumn(label: Text('ID')),
              DataColumn(
                label: const Text('Nombre'),
                onSort: (columnIndex, ascending) => ascending
                    ? Printer.d('Ordenar por Nombre Ascendente')
                    : Printer.d('Ordenar por Nombre Descendente'),
              ),
              const DataColumn(label: Text('Activo')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('Pequeñito')),
                DataCell(Text('Sí')),
                DataCell(Text('Acción')),
              ]),
              DataRow(cells: [
                DataCell(Text('2')),
                DataCell(Text('Mediano')),
                DataCell(Text('No')),
                DataCell(Text('Acción')),
              ]),
              DataRow(cells: [
                DataCell(Text('2')),
                DataCell(Text('Mediano')),
                DataCell(Text('No')),
                DataCell(Text('Acción')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

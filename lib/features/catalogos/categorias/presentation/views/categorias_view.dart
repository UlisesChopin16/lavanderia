import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

class CategoriasView extends ConsumerStatefulWidget {
  const CategoriasView({super.key});

  @override
  ConsumerState<CategoriasView> createState() => _CategoriasViewState();
}

class _CategoriasViewState extends ConsumerState<CategoriasView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Card(
          child: TableCardInfo(
            titleAddButton: 'Agregar categoría de ropa',
            onAddButtonPressed: () {
              // Acción al presionar el botón de agregar categoría
              Printer.d('Agregar Categoría presionado');
            },
            onSearchChanged: (value) {
              // Acción al cambiar el texto de búsqueda
              Printer.d('Buscar: $value');
            },
            dataTable: DataTable(
              sortAscending: false,
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
                // DataRow(cells: [
                //   DataCell(Text('1')),
                //   DataCell(Text('Pequeñito')),
                //   DataCell(Text('Sí')),
                // ]),
                // DataRow(cells: [
                //   DataCell(Text('2')),
                //   DataCell(Text('Mediano')),
                //   DataCell(Text('No')),
                // ]),
                // DataRow(cells: [
                //   DataCell(Text('2')),
                //   DataCell(Text('Mediano')),
                //   DataCell(Text('No')),
                // ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

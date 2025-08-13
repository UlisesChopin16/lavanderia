import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

class SizesView extends ConsumerStatefulWidget {
  const SizesView({super.key});

  @override
  ConsumerState<SizesView> createState() => _SizesViewState();
}

class _SizesViewState extends ConsumerState<SizesView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800,
        child: Card(
          child: TableCardInfo(
            titleAddButton: 'Agregar tamaño de ropa',
            actions: [
              // DataAction(
              //   icon: Icons.edit,
              //   tooltip: 'Editar',
              //   callbackIndex: (index) {
              //     // Acción al presionar el botón de editar
              //     print('Editar Tamaño en la fila $index');
              //   },
              // ),
              // DataAction(
              //   icon: Icons.delete,
              //   tooltip: 'Eliminar',
              //   callbackIndex: (index) {
              //     // Acción al presionar el botón de eliminar
              //     print('Eliminar Tamaño en la fila $index');
              //   },
              // ),
              // DataAction(
              //   icon: Icons.add,
              //   tooltip: 'Agregar',
              //   callbackIndex: (index) {
              //     // Acción al presionar el botón de agregar
              //     print('Agregar Tamaño en la fila $index');
              //   },
              // ),
            ],
            onAddButtonPressed: () {
              // Acción al presionar el botón de agregar tamaño
              print('Agregar Tamaño presionado');
            },
            onSearchChanged: (value) {
              // Acción al cambiar el texto de búsqueda
              print('Buscar: $value');
            },
            dataTable: DataTable(
              sortAscending: false,
              columns: [
                const DataColumn(label: Text('ID')),
                DataColumn(
                  label: const Text('Nombre'),
                  onSort: (columnIndex, ascending) => ascending
                      ? print('Ordenar por Nombre Ascendente')
                      : print('Ordenar por Nombre Descendente'),
                ),
                const DataColumn(label: Text('Activo')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('Pequeño')),
                  DataCell(Text('Sí')),
                ]),
                DataRow(cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Mediano')),
                  DataCell(Text('No')),
                ]),
                DataRow(cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Mediano')),
                  DataCell(Text('No')),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/catalogos/sizes/presentation/views/view_model/sizes_view_model.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

class SizesView extends ConsumerStatefulWidget {
  const SizesView({super.key});

  @override
  ConsumerState<SizesView> createState() => _SizesViewState();
}

class _SizesViewState extends ConsumerState<SizesView> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
    return Center(
      child: SizedBox(
        width: 800,
        child: Card(
          child: StreamBuilder(
              stream: sizeRopaNotifier.observeSizes(),
              builder: (context, asyncSnapshot) {
                return TableCardInfo(
                  titleAddButton: 'Agregar tamaño de ropa',
                  onAddButtonPressed: () {
                    // Acción al presionar el botón de agregar tamaño
                    index++;
                    sizeRopaNotifier.createSize('Nuevo Tamaño $index');
                  },
                  onSearchChanged: (value) {
                    // Acción al cambiar el texto de búsqueda
                    // print('Buscar: $value');
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
                      const DataColumn(label: Text('Fecha de creación')),
                    ],
                    rows: List.generate(
                      asyncSnapshot.data?.length ?? 0,
                      (index) {
                        final size = asyncSnapshot.data![index];
                        return DataRow(
                          cells: [
                            DataCell(Text(size.id.toString())),
                            DataCell(Text(size.nombre)),
                            DataCell(Text(size.estatus.value)),
                            DataCell(Text(size.fechaCreacion.toString())),
                            DataCell(
                              ActionsButtons(
                                actions: [
                                  DataAction(
                                    callbackIndex: () {},
                                    icon: Icons.abc,
                                    isNotEnabled: true,
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

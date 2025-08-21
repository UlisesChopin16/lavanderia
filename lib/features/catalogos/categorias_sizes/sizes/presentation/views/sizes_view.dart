import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/types/column_names_type.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/presentation/views/view_model/sizes_view_model.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/presentation/widgets/small_view.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

class SizesView extends ConsumerStatefulWidget {
  const SizesView({super.key});

  @override
  ConsumerState<SizesView> createState() => _SizesViewState();
}

class _SizesViewState extends ConsumerState<SizesView> {
  int index = 0;

  final listEstatus = EstatusType.values;
  final listOrden = ColumnNamesType.values;

  @override
  Widget build(BuildContext context) {
    final sizeRopaNotifier = ref.read(sizesViewModelProvider.notifier);
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    final filtros = ref.watch(
      sizesViewModelProvider.select(
        (value) => value.filtros,
      ),
    );
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 800,
          child: Card(
            child: StreamBuilder(
              stream: sizeRopaNotifier.observeSizes(),
              builder: (context, asyncSnapshot) {
                return TableCardInfo(
                  showActions: !blockUI,
                  haveFilters: filtros.haveFilters,
                  titleAddButton: 'Agregar tamaño de ropa',
                  onClearFilters: () => sizeRopaNotifier.clearFilters(),
                  onAddButtonPressed: () {
                    // Acción al presionar el botón de agregar tamaño
                    index++;
                    sizeRopaNotifier.createSize('Nuevo Tamaño $index');
                  },
                  onSearchChanged: sizeRopaNotifier.setNombre,
                  onSortChange: sizeRopaNotifier.setSort,
                  filters: [
                    for (var estatus in listEstatus)
                      FilterChip(
                        label: Text(estatus.value),
                        selected: filtros.estatus == estatus,
                        onSelected: (isSelected) {
                          // Acción al seleccionar/deseleccionar el filtro
                          sizeRopaNotifier.setEstatus(estatus);
                        },
                      ),
                  ],
                  columns: [
                    ...List.generate(
                      listOrden.length,
                      (index) {
                        final orden = listOrden[index];
                        return DataColumn(
                          label: Text(orden.title),
                          onSort: (columnIndex, ascending) =>
                              sizeRopaNotifier.setOrdenAndSort(orden, ascending),
                        );
                      },
                    ),
                    // DataColumn(label: const Text('ID'), onSort: setOrdenAndSort),
                    // DataColumn(
                    //   label: const Text('Nombre'),
                    //   onSort: setOrdenAndSort,
                    // ),
                    // DataColumn(label: const Text('Activo'), onSort: setOrdenAndSort),
                    // DataColumn(label: const Text('Fecha de creación'), onSort: setOrdenAndSort),
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
                          DataCell(Text(size.fechaCreacion.formatDate)),
                          DataCell(
                            ActionsButtons(
                              actions: [
                                DataAction(
                                  callbackIndex: () {},
                                  icon: Icons.abc,
                                  isNotEnabled: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  smallView: SmallView(rows: asyncSnapshot.data ?? []),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

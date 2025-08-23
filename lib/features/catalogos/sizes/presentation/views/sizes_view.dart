import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/catalogos/presentation/dialogs/nombre_dialog.dart';
import 'package:lavanderia/features/catalogos/presentation/types/column_names_type.dart';
import 'package:lavanderia/features/catalogos/presentation/widgets/filtro_orden.dart';
import 'package:lavanderia/features/catalogos/sizes/presentation/views/view_model/sizes_view_model.dart';
import 'package:lavanderia/features/catalogos/sizes/presentation/widgets/actions_row.dart';
import 'package:lavanderia/features/catalogos/sizes/presentation/widgets/small_view.dart';
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
    final isSmall = MediaQuery.of(context).size.width < 950;
    Printer.i(filtros);
    return Center(
      child: SizedBox(
        width: 900,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.only(top: 16.0),
            child: StreamBuilder(
              stream: sizeRopaNotifier.observeSizes(),
              builder: (context, asyncSnapshot) {
                return TableCardInfo(
                  isSmall: isSmall,
                  ascending: filtros.ascendente,
                  sortColumnIndex: filtros.ordenamiento.index,
                  showActions: !blockUI,
                  haveFilters: filtros.haveFilters,
                  titleAddButton: 'Agregar tamaño de ropa',
                  onClearFilters: sizeRopaNotifier.clearFilters,
                  onAddButtonPressed: () async {
                    // Acción al presionar el botón de agregar tamaño
                    final nombre = await showNombreDialog();
                    if (nombre != null) {
                      sizeRopaNotifier.createSize(nombre);
                    }
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
                    FiltroOrden(
                      ordenamiento: filtros.ordenamiento,
                      ascendente: filtros.ascendente,
                      onOrdenamientoChanged: sizeRopaNotifier.setOrden,
                      onAscendenteChanged: sizeRopaNotifier.setSort,
                    )
                  ],
                  columns: [
                    ...List.generate(
                      listOrden.length,
                      (index) {
                        final orden = listOrden[index];
                        return DataColumn(
                          label: Text(
                            orden.title,
                          ),
                          onSort: (columnIndex, ascending) {
                            sizeRopaNotifier.setOrdenAndSort(orden, ascending);
                            setState(() {});
                          },
                        );
                      },
                    ),
                    // if (thereAreInactives)
                    //   const DataColumn(
                    //     label: Text('Fecha de Eliminación'),
                    //   ),
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
                          DataCell(Text(size.fechaCreacion.formatFullDate)),
                          DataCell(Text(size.fechaEliminacion.formatFullDate)),
                          DataCell(
                            ActionsRow(size: size, isSmall: isSmall),
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

  Future<String?> showNombreDialog() {
    const title = 'Nuevo tamaño de ropa';
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return const NombreDialog(
          title: title,
          nombre: '',
          label: 'Nombre del tamaño',
          hintText: 'Ej: Chica, Mediana, Kingsize',
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/presentation/dialogs/create_categoria.dart';
import 'package:lavanderia/features/catalogos/categorias/presentation/types/columns_categoria_type.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

import '../widgets/widgets.dart';
import 'view_model/categoria_view_model.dart';

class CategoriaView extends ConsumerStatefulWidget {
  const CategoriaView({super.key});

  @override
  ConsumerState<CategoriaView> createState() => _CategoriaViewState();
}

class _CategoriaViewState extends ConsumerState<CategoriaView> {
  int index = 0;

  final listEstatus = EstatusType.values;
  final listOrden = ColumnsCategoriaType.values;

  @override
  Widget build(BuildContext context) {
    _addErrorListener();
    _addSuccessListener();
    final categoriaNotifier = ref.read(categoriaViewModelProvider.notifier);

    final filtros = ref.watch(
      categoriaViewModelProvider.select(
        (value) => value.filtros,
      ),
    );

    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    return Center(
      child: SizedBox(
        width: 1000,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24.0),
            child: StreamBuilder(
              stream: categoriaNotifier.observeCategorias(),
              builder: (context, asyncSnapshot) {
                return TableCardInfo(
                  showAddButton: !blockUI,
                  ascending: filtros.ascendente,
                  sortColumnIndex: filtros.ordenamiento.index,
                  haveFilters: filtros.haveFilters,
                  titleAddButton: 'Agregar categoría de ropa',
                  onClearFilters: categoriaNotifier.clearFilters,
                  onAddButtonPressed: onAddCategoria,
                  onSearchChanged: categoriaNotifier.setNombre,
                  onSortChange: categoriaNotifier.setSort,
                  filters: [
                    for (var estatus in listEstatus)
                      FilterChip(
                        label: Text(estatus.value),
                        selected: filtros.estatus == estatus,
                        onSelected: (isSelected) {
                          // Acción al seleccionar/deseleccionar el filtro
                          categoriaNotifier.setEstatus(estatus);
                        },
                      ),
                    FiltroOrden(
                      ordenamiento: filtros.ordenamiento,
                      ascendente: filtros.ascendente,
                      onOrdenamientoChanged: categoriaNotifier.setOrden,
                      onAscendenteChanged: categoriaNotifier.setSort,
                    ),
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
                            categoriaNotifier.setOrdenAndSort(orden, ascending);
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
                      final categoria = asyncSnapshot.data![index];
                      return DataRow(
                        cells: [
                          DataCell(Text(categoria.id.toString())),
                          DataCell(Text(categoria.nombre)),
                          DataCell(Text(categoria.estatus.value)),
                          DataCell(Text(categoria.diasEntrega.toString())),
                          DataCell(Text(categoria.fechaCreacion.formatFullDate)),
                          DataCell(Text(categoria.fechaEliminacion.formatFullDate)),
                          DataCell(ActionsRow(categoria: categoria)),
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

  void onAddCategoria() async {
    await showNombreDialog();
  }

  Future<String?> showNombreDialog() {
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return const CreateCategoria();
      },
    );
  }

  void _addErrorListener() {
    ref.listen(categoriaViewModelProvider.select((state) => state.errorMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showErrorDialog(next);
      }
    });
  }

  void _addSuccessListener() {
    ref.listen(categoriaViewModelProvider.select((state) => state.successMessage), (
      previous,
      next,
    ) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showSuccessDialog(next);
      }
    });
  }
}

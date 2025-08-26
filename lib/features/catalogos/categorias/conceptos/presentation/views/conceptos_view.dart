import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/categorias/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/categorias/conceptos/presentation/dialogs/add_concepto_dialog.dart';
import 'package:lavanderia/features/catalogos/presentation/types/column_names_type.dart';
import 'package:lavanderia/features/catalogos/presentation/widgets/filtro_orden.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

import '../widgets/widgets.dart';
import 'view_model/conceptos_view_model.dart';

class ConceptosView extends ConsumerStatefulWidget {
  const ConceptosView({
    super.key,
    required this.categoria,
  });

  final CategoriaServicioEntity categoria;

  @override
  ConsumerState<ConceptosView> createState() => _ConceptosViewState();
}

class _ConceptosViewState extends ConsumerState<ConceptosView> {
  int index = 0;

  final listEstatus = EstatusType.values;
  final listOrden = ColumnNamesType.values;

  CategoriaServicioEntity get categoria => widget.categoria;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final conceptoNotifier = ref.read(conceptosViewModelProvider.notifier);
      conceptoNotifier.init(categoria);
    });
  }

  @override
  Widget build(BuildContext context) {
    _addErrorListener();
    _addSuccessListener();
    final conceptosNotifier = ref.read(conceptosViewModelProvider.notifier);
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    final filtros = ref.watch(
      conceptosViewModelProvider.select(
        (value) => value.filtros,
      ),
    );
    final isSmall = MediaQuery.of(context).size.width < 950;

    return BaseDialog(
      title: 'Conceptos de ${categoria.nombre.capitalize()}',
      icon: const Icon(IconsManager.clotheIcon),
      content: Center(
        child: SizedBox(
          width: 1000,
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: conceptosNotifier.observeConceptos(categoria.id),
              builder: (context, asyncSnapshot) {
                return TableCardInfo(
                  isSmall: isSmall,
                  ascending: filtros.ascendente,
                  sortColumnIndex: filtros.ordenamiento.index,
                  showActions: !blockUI,
                  haveFilters: filtros.haveFilters,
                  titleAddButton: 'Agregar concepto de ropa',
                  onClearFilters: conceptosNotifier.clearFilters,
                  onAddButtonPressed: showAddConceptDialog,
                  onSearchChanged: conceptosNotifier.setNombre,
                  onSortChange: conceptosNotifier.setSort,
                  filters: [
                    for (var estatus in listEstatus)
                      FilterChip(
                        label: Text(estatus.value),
                        selected: filtros.estatus == estatus,
                        onSelected: (isSelected) {
                          // Acción al seleccionar/deseleccionar el filtro
                          conceptosNotifier.setEstatus(estatus);
                        },
                      ),
                    FiltroOrden(
                      ordenamiento: filtros.ordenamiento,
                      ascendente: filtros.ascendente,
                      onOrdenamientoChanged: conceptosNotifier.setOrden,
                      onAscendenteChanged: conceptosNotifier.setSort,
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
                            conceptosNotifier.setOrdenAndSort(orden, ascending);
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
                      final concepto = asyncSnapshot.data![index];
                      return DataRow(
                        cells: [
                          DataCell(Text(concepto.id.toString())),
                          DataCell(Text(concepto.nombre)),
                          DataCell(Text(concepto.estatus.value)),
                          DataCell(Text(concepto.fechaCreacion.formatFullDate)),
                          DataCell(Text(concepto.fechaEliminacion.formatFullDate)),
                          DataCell(
                            ActionsRow(concepto: concepto, isSmall: isSmall),
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

  // void onAddConcepto() async {
  //   final conceptosNotifier = ref.read(conceptosViewModelProvider.notifier);
  //   // Acción al presionar el botón de agregar concepto
  //   await showNombreDialog();

  //   if (nombre == null) return;
  //   if (!mounted) return;

  //   final confirm = await context.showWarningDialog(
  //     message: '¿Estás seguro de agregar el concepto "$nombre"?',
  //   );

  // }

  Future<void> showAddConceptDialog() {
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return const AddConceptoDialog();
      },
    );
  }

  void _addErrorListener() {
    ref.listen(conceptosViewModelProvider.select((state) => state.errorMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showErrorDialog(next);
      }
    });
  }

  void _addSuccessListener() {
    ref.listen(conceptosViewModelProvider.select((state) => state.successMessage),
        (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showSuccessDialog(next);
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/presentation/widgets/dropdown_clothe_sizes.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

import '../dialogs/create_precio_dialog.dart';
import '../widgets/actions_row.dart';
import '../widgets/filtros/filtros.dart';
import 'small_view.dart';

class PreciosView extends ConsumerStatefulWidget {
  final CategoriaServicioEntity? categoria;
  final bool showInCard;
  final bool? blockUI;
  const PreciosView({
    super.key,
    this.categoria,
    this.showInCard = true,
    this.blockUI,
  });

  @override
  ConsumerState<PreciosView> createState() => _PreciosViewState();
}

class _PreciosViewState extends ConsumerState<PreciosView> {
  final scrollController = ScrollController();

  int index = 0;

  final listEstatus = EstatusType.values;

  CategoriaServicioEntity? get categoria => widget.categoria;

  List<ColumnPreciosName> get columns {
    List<ColumnPreciosName> values = List.from(ColumnPreciosName.values);

    if (categoria != null) {
      values.remove(ColumnPreciosName.categoria);
    }
    return values;
  }

  int get indexColumn {
    final ordenamiento = ref.watch(
      preciosViewModelProvider.select((state) => state.filtros.ordenamiento),
    );
    if (categoria != null) {
      return columns.indexWhere((element) => element == ordenamiento);
    }
    return ordenamiento.index;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final preciosNotifier = ref.read(preciosViewModelProvider.notifier);
      // Acción a realizar después de que se haya construido el widget
      preciosNotifier.clearAll();
      preciosNotifier.init(categoria);

      await preciosNotifier.getCategorias();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _addErrorListener();
    _addSuccessListener();
    final preciosNotifier = ref.read(preciosViewModelProvider.notifier);
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => widget.blockUI ?? value.blockUI),
    );
    final filtros = ref.watch(
      preciosViewModelProvider.select(
        (value) => value.filtros,
      ),
    );

    final child = StreamBuilder(
      stream: preciosNotifier.observePrecios(),
      builder: (context, asyncSnapshot) {
        return TableCardInfo(
          showActions: !blockUI,
          showAddButton: !blockUI,
          ascending: filtros.ascendente,
          sortColumnIndex: indexColumn,
          haveFilters: filtros.haveFilters,
          titleAddButton: 'Agregar conceptos de ropa',
          onClearFilters: preciosNotifier.clearFilters,
          onAddButtonPressed: onAddConcepto,
          onSearchChanged: preciosNotifier.setNombre,
          onSortChange: preciosNotifier.setSort,
          // scrollController: scrollController,
          filters: [
            for (var estatus in listEstatus)
              FilterChip(
                label: Text(estatus.value),
                selected: filtros.estatus == estatus,
                onSelected: (isSelected) {
                  // Acción al seleccionar/deseleccionar el filtro
                  preciosNotifier.setEstatus(estatus);
                },
              ),
            if (categoria == null) FiltroCategoria(categoriaValue: filtros.categoria),
            DropdownClotheSizes(
              clotheSize: filtros.clotheSize,
              onSizeChanged: preciosNotifier.setSizeRopa,
            ),
            FiltroOrden(
              ordenamiento: filtros.ordenamiento,
              ascendente: filtros.ascendente,
              onOrdenamientoChanged: preciosNotifier.setOrden,
              onAscendenteChanged: preciosNotifier.setSort,
              columnNames: columns,
            ),
          ],
          columns: [
            ...List.generate(
              columns.length,
              (index) {
                final column = columns[index];
                return DataColumn(
                  label: Text(
                    column.title,
                  ),
                  onSort: (columnIndex, ascending) {
                    preciosNotifier.setOrdenAndSort(column, ascending);
                    setState(() {});
                  },
                );
              },
            ),
          ],
          rows: List.generate(
            asyncSnapshot.data?.length ?? 0,
            (index) {
              final precio = asyncSnapshot.data![index];
              return DataRow(
                cells: [
                  DataCell(Text(precio.idPrecio.toString())),
                  DataCell(Text(precio.nombreConcepto)),
                  if (categoria == null) DataCell(Text(precio.categoria.nombre)),
                  DataCell(Text(precio.size.description)),
                  DataCell(Text(precio.tipoUnidad.value)),
                  DataCell(Text(precio.diasEntrega.toString())),
                  DataCell(Text('\$ ${precio.importe.toString()}')),
                  DataCell(Text(precio.estatus.value)),
                  DataCell(Text(precio.fechaCreacion.formatFullDate)),
                  DataCell(Text(precio.fechaEliminacion.formatFullDate)),
                  DataCell(ActionsRow(precio: precio)),
                ],
              );
            },
          ),
          smallView: SmallView(rows: asyncSnapshot.data ?? []),
        );
      },
    );

    final newChild = !widget.showInCard ? child : Card(child: child);

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: 1400,
            child: newChild,
          ),
        ),
      ),
    );
  }

  void onAddConcepto() async {
    final (categorias) = ref.watch(
      preciosViewModelProvider.select(
        (state) => (state.categorias),
      ),
    );

    // Acción al presionar el botón de agregar concepto
    if (categorias.isEmpty) {
      context.showErrorDialog(
        'No hay categorías de ropa disponibles. Por favor, agrega una categoría primero.',
      );
      return;
    }

    await showCreateDialog();
  }

  Future<String?> showCreateDialog() {
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return const CreatePrecioDialog();
      },
    );
  }

  void _addErrorListener() {
    ref.listen(preciosViewModelProvider.select((state) => state.errorMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showErrorDialog(next);
      }
    });
  }

  void _addSuccessListener() {
    ref.listen(preciosViewModelProvider.select((state) => state.successMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showSuccessDialog(next);
      }
    });
  }
}

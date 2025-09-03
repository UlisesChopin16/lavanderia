import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/filters/filtros_clientes.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/views/view_model/clientes_view_model.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

import '../dialogs/create_cliente_dialog.dart';
import '../widgets/actions_row.dart';
import '../widgets/filtro_orden.dart';
import '../widgets/small_view.dart';

class ClientesView extends ConsumerStatefulWidget {
  const ClientesView({super.key});

  @override
  ConsumerState<ClientesView> createState() => _ClientesViewState();
}

class _ClientesViewState extends ConsumerState<ClientesView> {
  int index = 0;

  final listOrden = ColumnClientesName.values;

  @override
  Widget build(BuildContext context) {
    _addErrorListener();
    _addSuccessListener();
    final clientesNotifier = ref.read(clientesViewModelProvider.notifier);
    final filtros = ref.watch(
      clientesViewModelProvider.select(
        (value) => value.filtros,
      ),
    );
    // final blockUI = ref.watch(
    //   configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    // );

    return Center(
      child: SizedBox(
        width: 1120,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: StreamBuilder(
              stream: clientesNotifier.observeClientes(),
              builder: (context, asyncSnapshot) {
                return TableCardInfo(
                  showAddButton: true,
                  ascending: filtros.ascendente,
                  sortColumnIndex: filtros.ordenamiento.index,
                  haveFilters: filtros.haveFilters,
                  titleAddButton: 'Agregar nuevo cliente',
                  onClearFilters: clientesNotifier.clearFilters,
                  onAddButtonPressed: onAddCliente,
                  onSearchChanged: clientesNotifier.setNombre,
                  onSortChange: clientesNotifier.setSort,
                  filters: [
                    FiltroOrden(
                      ordenamiento: filtros.ordenamiento,
                      ascendente: filtros.ascendente,
                      onOrdenamientoChanged: clientesNotifier.setOrden,
                      onAscendenteChanged: clientesNotifier.setSort,
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
                            clientesNotifier.setOrdenAndSort(orden, ascending);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                  rows: List.generate(
                    asyncSnapshot.data?.length ?? 0,
                    (index) {
                      final cliente = asyncSnapshot.data![index];
                      return DataRow(
                        cells: [
                          DataCell(Text(cliente.id.toString())),
                          DataCell(Text(cliente.nombres)),
                          DataCell(Text(cliente.apellidos)),
                          DataCell(Text(cliente.telefono)),
                          DataCell(Text(cliente.correo)),
                          DataCell(Text(cliente.fechaCreacion.formatFullDate)),
                          DataCell(ActionsRow(cliente: cliente)),
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

  void onAddCliente() async {
    await showCreateDialog();
  }

  Future<String?> showCreateDialog() {
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return const CreateClienteDialog();
      },
    );
  }

  void _addErrorListener() {
    ref.listen(clientesViewModelProvider.select((state) => state.errorMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showErrorDialog(next);
      }
    });
  }

  void _addSuccessListener() {
    ref.listen(clientesViewModelProvider.select((state) => state.successMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showSuccessDialog(next);
      }
    });
  }
}

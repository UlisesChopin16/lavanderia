import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/filtros/filtros_ordenes.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/view/view_model/lista_ordenes_view_model.dart';
import 'package:lavanderia/shared/widgets/date_range_picker.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';

import '../widgets/widgets.dart';

class ListaOrdenesView extends ConsumerStatefulWidget {
  const ListaOrdenesView({super.key});

  @override
  ConsumerState<ListaOrdenesView> createState() => _ListaOrdenesViewState();
}

class _ListaOrdenesViewState extends ConsumerState<ListaOrdenesView> {
  int index = 0;

  // final listEstatus = EstatusType.values;
  static const listOrden = ColumnsOrdenesNames.values;

  @override
  Widget build(BuildContext context) {
    _addErrorListener();
    _addSuccessListener();
    final listaOrdenesNotifier = ref.read(listaOrdenesViewModelProvider.notifier);
    final (filtros, inicio, fin) = ref.watch(
      listaOrdenesViewModelProvider.select(
        (value) => (value.filtros, value.inicioItems, value.finItems),
      ),
    );
    // final blockUI = ref.watch(
    //   configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    // );

    return Scaffold(
      floatingActionButton: const RowPages(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: const EdgeInsets.all(24),
                child: StreamBuilder(
                  stream: listaOrdenesNotifier.observeOrders(),
                  builder: (context, asyncSnapshot) {
                    final data = asyncSnapshot.data ?? [];
                    final subList = data.sublist(inicio, fin);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      listaOrdenesNotifier.setTotalItems(data.length);
                    });

                    return TableCardInfo(
                      showAddButton: false,
                      ascending: filtros.ascendente,
                      sortColumnIndex: filtros.ordenamiento.index,
                      haveFilters: filtros.haveFilters,
                      titleAddButton: 'Agregar tamaño de ropa',
                      onClearFilters: listaOrdenesNotifier.clearFiltros,
                      // onAddButtonPressed: onAddSize,
                      onSearchChanged: listaOrdenesNotifier.setNombre,
                      onSortChange: listaOrdenesNotifier.setSort,
                      filters: [
                        DateRangePicker(
                          selectedDates: filtros.fechas,
                          changeDate: listaOrdenesNotifier.setFechas,
                          labelText: 'Fechas de creación',
                          showDelete: filtros.fechas.isNotEmpty,
                          onDelete: listaOrdenesNotifier.clearFechas,
                        ),
                        FiltroOrden(
                          ordenamiento: filtros.ordenamiento,
                          ascendente: filtros.ascendente,
                          onOrdenamientoChanged: listaOrdenesNotifier.setOrden,
                          onAscendenteChanged: listaOrdenesNotifier.setSort,
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
                                listaOrdenesNotifier.setOrdenAndSort(orden, ascending);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ],
                      rows: List.generate(
                        subList.length,
                        (index) {
                          final newIndex = index + 1 + inicio;
                          final ordenServicio = subList[index];
                          return DataRow(
                            cells: [
                              DataCell(Text(newIndex.toString())),
                              DataCell(Text(ordenServicio.folio)),
                              DataCell(Text(ordenServicio.cliente.fullName)),
                              DataCell(Text(ordenServicio.estatus.value)),
                              DataCell(Text(ordenServicio.total.toStringAsFixed(2))),
                              DataCell(Text(ordenServicio.restante.toStringAsFixed(2))),
                              DataCell(Text(ordenServicio.history.metodoPago?.value ?? 'N/A')),
                              DataCell(Text(ordenServicio.fechaCreacion.formatFullDate)),
                              DataCell(Text(ordenServicio.history.fecha.formatFullDate)),
                              DataCell(Text(ordenServicio.fechaCierre.formatFullDate)),
                              DataCell(ActionsRow(ordenServicio: ordenServicio)),
                            ],
                          );
                        },
                      ),
                      smallView: SmallView(rows: subList),
                    );
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  void _addErrorListener() {
    ref.listen(listaOrdenesViewModelProvider.select((state) => state.errorMessage), (
      previous,
      next,
    ) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showErrorDialog(next);
      }
    });
  }

  void _addSuccessListener() {
    ref.listen(listaOrdenesViewModelProvider.select((state) => state.successMessage), (
      previous,
      next,
    ) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showSuccessDialog(next);
      }
    });
  }

  // void sendMail() async {
  //   final smtpServer = ConstantsManager.smtpServer;
  //   final mail = ConstantsManager.mailUsername;
  //   final message = Message()
  //     ..from = Address(mail, 'Mi App Flutter')
  //     ..recipients.add('uliseschopin@outlook.com')
  //     ..subject = 'Correo de prueba desde Flutter'
  //     ..text = 'Hola! Este es un correo enviado desde Flutter con SMTP.'
  //     // ..attachments.add(FileAttachment.);
  //     ..html = "<h1>Correo en HTML</h1><p>Enviado desde Flutter 🚀</p>";

  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Correo enviado: ${sendReport.toString()}');
  //   } on MailerException catch (e) {
  //     print('Error al enviar el correo: $e');
  //     for (var p in e.problems) {
  //       print('Problema: ${p.code}: ${p.msg}');
  //     }
  //   }
  // }
}

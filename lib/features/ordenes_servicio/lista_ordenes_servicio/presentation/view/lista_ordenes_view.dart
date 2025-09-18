import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/filtros/filtros_ordenes.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/view/view_model/lista_ordenes_view_model.dart';
import 'package:lavanderia/shared/widgets/table_card_info.dart';
import 'package:mailer/mailer.dart';

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
    final filtros = ref.watch(
      listaOrdenesViewModelProvider.select(
        (value) => value.filtros,
      ),
    );
    // final blockUI = ref.watch(
    //   configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    // );

    return Center(
      child: SizedBox(
        width: 1000,
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(24),
            child: StreamBuilder(
              stream: listaOrdenesNotifier.observeOrders(),
              builder: (context, asyncSnapshot) {
                return TableCardInfo(
                  showAddButton: false,
                  ascending: filtros.ascendente,
                  sortColumnIndex: filtros.ordenamiento.index,
                  haveFilters: filtros.haveFilters,
                  titleAddButton: 'Agregar tamaño de ropa',
                  onClearFilters: listaOrdenesNotifier.clearFilters,
                  onAddButtonPressed: onAddSize,
                  onSearchChanged: listaOrdenesNotifier.setNombre,
                  onSortChange: listaOrdenesNotifier.setSort,
                  filters: [
                    // for (var estatus in listEstatus)
                    //   FilterChip(
                    //     label: Text(estatus.value),
                    //     selected: filtros.estatus == estatus,
                    //     onSelected: (isSelected) {
                    //       // Acción al seleccionar/deseleccionar el filtro
                    //       listaOrdenesNotifier.setEstatus(estatus);
                    //     },
                    //   ),
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
                    asyncSnapshot.data?.length ?? 0,
                    (index) {
                      final ordenServicio = asyncSnapshot.data![index];
                      return DataRow(
                        cells: [
                          DataCell(Text(ordenServicio.id.toString())),
                          DataCell(Text(ordenServicio.nombre)),
                          DataCell(Text(ordenServicio.estatus.value)),
                          DataCell(Text(ordenServicio.fechaCreacion.formatFullDate)),
                          DataCell(Text(ordenServicio.fechaEliminacion.formatFullDate)),
                          DataCell(ActionsRow(size: size)),
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

  void onAddSize() async {
    final listaOrdenesNotifier = ref.read(sizesViewModelProvider.notifier);
    // Acción al presionar el botón de agregar tamaño
    final nombre = await showNombreDialog();

    if (nombre == null) return;
    if (!mounted) return;

    final confirm = await context.showWarningDialog(
      message: '¿Estás seguro de agregar el tamaño "$nombre"?',
    );

    if (confirm == true) {
      listaOrdenesNotifier.createSize(nombre);
    }
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

  void _addErrorListener() {
    ref.listen(sizesViewModelProvider.select((state) => state.errorMessage), (previous, next) {
      // Acción al cambiar el estado del notifier
      if (next.isNotEmpty) {
        context.showErrorDialog(next);
      }
    });
  }

  void _addSuccessListener() {
    ref.listen(sizesViewModelProvider.select((state) => state.successMessage), (previous, next) {
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

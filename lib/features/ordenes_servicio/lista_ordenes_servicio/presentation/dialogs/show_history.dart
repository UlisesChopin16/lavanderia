import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/history_item/history_item_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/view/view_model/lista_ordenes_view_model.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';

class ShowHistory extends ConsumerStatefulWidget {
  final OrdenConDetallesEntity orden;
  const ShowHistory({super.key, required this.orden});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowHistoryState();
}

class _ShowHistoryState extends ConsumerState<ShowHistory> {
  List<HistoryItemEntity> history = [];

  OrdenConDetallesEntity get orden => widget.orden;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final listaOrdenesNotifier = ref.read(listaOrdenesViewModelProvider.notifier);
    final newHistory = await listaOrdenesNotifier.obtainHistory(orden.id);
    setState(() {
      history = newHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Historial de la orden ${orden.folio}',
      showCloseButton: false,
      // content: FutureBuilder(
      //   future: fetchHistory(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else if (!snapshot.hasData || history.isEmpty) {
      //       return const Center(child: Text('No hay historial disponible.'));
      //     } else {
      //       return SizedBox(
      //         width: double.maxFinite,
      //         child: ListView.builder(
      //           shrinkWrap: true,
      //           itemCount: history.length,
      //           itemBuilder: (context, index) {
      //             final item = history[index];
      //             return Column(
      //               children: [
      //                 ListTile(
      //                   leading: const CircleAvatar(
      //                     child: Icon(Icons.history_rounded),
      //                   ),
      //                   title: Text(item.metodoPagoString),
      //                   subtitle: Text('Fecha: ${item.fecha.formatFullDate}'),
      //                 ),
      //                 Align(
      //                   alignment: Alignment.centerRight,
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
      //                     child: Text(
      //                       'Monto: \$${item.monto.toStringAsFixed(2)}',
      //                       style: const TextStyle(fontWeight: FontWeight.bold),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             );
      //           },
      //         ),
      //       );
      //     }
      //   },
      // ),
      content: history.isEmpty
          ? const Center(child: Text('No hay historial disponible.'))
          : SizedBox(
              width: 500,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.history_rounded),
                    ),
                    title: Text(item.metodoPagoString),
                    subtitle: Text('Fecha: ${item.fecha.formatFullDate}'),
                    trailing: Text('Adelanto:\n\$${item.monto.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
      onActionPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

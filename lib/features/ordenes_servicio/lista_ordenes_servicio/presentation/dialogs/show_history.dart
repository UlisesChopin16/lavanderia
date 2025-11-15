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
      content: history.isEmpty
          ? const Center(child: Text('No hay historial disponible.'))
          : SizedBox(
              width: 400,
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  ListHistory(history: history),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverFooterDelegate(
                      history: history,
                      total: orden.total,
                      restante: orden.restante,
                    ),
                  ),
                ],
              ),
            ),
      onActionPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class ListHistory extends StatelessWidget {
  final List<HistoryItemEntity> history;
  const ListHistory({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final monto = item.monto.toStringAsFixed(2);
        final restante = item.restante;
        final newRestante = (restante < 0 ? 0.0 : restante).toStringAsFixed(2);
        // return ListTile(
        //   leading: const CircleAvatar(
        //     child: Icon(Icons.history_rounded),
        //   ),
        //   title: Text(item.metodoPagoString),
        //   subtitle: Text('Fecha: ${item.fecha.formatFullDate}'),
        //   trailing: Text('Adelanto:\n\$${item.monto.toStringAsFixed(2)}'),
        // );
        return Card(
          margin: const .symmetric(vertical: 8),
          child: Padding(
            padding: const .symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              spacing: 16,
              children: [
                const CircleAvatar(
                  child: Icon(Icons.history_rounded),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 5,
                    children: [
                      Text(
                        'Fecha: ${item.fecha.formatFullDate}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        spacing: 15,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              const Text('Abono'),
                              Text('\$$monto'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              const Text('Restante'),
                              Text('\$$newRestante'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              const Text('Metodo de pago'),
                              Text('${item.metodoPago?.value}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SliverFooterDelegate extends SliverPersistentHeaderDelegate {
  final List<HistoryItemEntity> history;
  final double total;
  final double restante;

  const SliverFooterDelegate({
    required this.history,
    required this.total,
    required this.restante,
  });

  @override
  double get minExtent => 80;

  @override
  double get maxExtent => 80;

  double get totalAbonado {
    return history.fold(0.0, (previousValue, element) => previousValue + element.monto);
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final abonado = totalAbonado.toStringAsFixed(2);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                'Total abonado',
                style: TextStyle(
                  // fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$$abonado',
                style: const TextStyle(
                  // fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Restante',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$$restante',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$$total',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

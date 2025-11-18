import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/dialogs/show_history/view_model/show_history_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/widgets/estatus_container.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/animating_loading.dart';

class ShowHistory extends ConsumerStatefulWidget {
  final OrdenConDetallesEntity orden;
  const ShowHistory({super.key, required this.orden});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowHistoryState();
}

const duration = Duration(milliseconds: 300);

class _ShowHistoryState extends ConsumerState<ShowHistory> {
  OrdenConDetallesEntity get orden => widget.orden;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(showHistoryViewModelProvider.notifier).initiate(orden);
      ref.read(showHistoryViewModelProvider.notifier).fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final (history, isLoading) = ref.watch(
      showHistoryViewModelProvider.select(
        (value) => (value.history, value.isLoading),
      ),
    );
    return BaseDialog(
      title: 'Historial de la orden ${orden.folio}',
      showCloseButton: false,
      icon: const CircleAvatar(
        child: Icon(Icons.history_rounded),
      ),
      content: AnimatingLoading(
        isLoading: isLoading,
        child: history.isEmpty
            ? const Center(child: Text('No hay historial disponible.'))
            : SizedBox(
                width: 400,
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverPersistentHeader(
                      pinned: false,
                      floating: true,
                      delegate: SliverFooterDelegate(
                        history: history,
                        orden: orden,
                      ),
                    ),
                    const ListHistory(),
                  ],
                ),
              ),
      ),
      onActionPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class ListHistory extends ConsumerWidget {
  const ListHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(
      showHistoryViewModelProvider.select(
        (value) => value.history,
      ),
    );
    return SliverList.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final monto = item.monto.toStringAsFixed(2);
        final restante = item.restante;
        final newRestante = (restante < 0 ? 0.0 : restante).toStringAsFixed(2);
        return Card(
          // margin: const .symmetric(vertical: 8),
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
  final OrdenConDetallesEntity orden;
  final List<HistoryItemEntity> history;

  const SliverFooterDelegate({required this.orden, required this.history});

  @override
  double get minExtent => 95;

  @override
  double get maxExtent => 95;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const DataInfo();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class DataInfo extends ConsumerWidget {
  const DataInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (estatus, totalAbonado, restante, total) = ref.watch(
      showHistoryViewModelProvider.select(
        (value) => (value.estatus, value.totalAbonado, value.restante, value.total),
      ),
    );

    final abonado = totalAbonado.toStringAsFixed(2);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const .all(5.0),
        child: Column(
          spacing: 5,
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: EstatusContainer(estatus: estatus)
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceEvenly,
              crossAxisAlignment: .center,
              children: [
                ColumnInfo(title: '+ Abonado', value: '+ \$$abonado', color: Colors.green),
                ColumnInfo(
                  title: '- Restante',
                  value: '- \$${restante.toStringAsFixed(2)}',
                  color: Colors.red,
                ),
                ColumnInfo(
                  title: 'Total',
                  value: '\$${total.toStringAsFixed(2)}',
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnInfo extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  const ColumnInfo({super.key, required this.title, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: FontWeight.w500,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: style,
        ),
        Text(
          value,
          style: style,
        ),
      ],
    );
  }
}

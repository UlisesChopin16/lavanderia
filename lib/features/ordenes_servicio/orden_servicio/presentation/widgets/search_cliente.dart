import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/cliente_entity.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/dialogs/create_cliente_dialog.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/widgets/item_cliente.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/view/view_model/orden_servicio_view_model.dart';

class SearchCliente extends ConsumerWidget {
  const SearchCliente({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenNotifier = ref.read(ordenServicioViewProvider.notifier);

    final (clientes, clienteSeleccionado, hasCliente) = ref.watch(
      ordenServicioViewProvider.select(
        (value) => (value.clientes, value.clienteSeleccionado, value.orden.hasCliente),
      ),
    );

    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    final blackColor = Theme.of(context).colorScheme.surfaceContainerLow;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final newColor = isDark ? color : blackColor;
    return Column(
      children: [
        const _SearchBar(),
        // const SizedBox(height: 10),
        if (hasCliente) ...[
          const SizedBox(height: 5),
          Card(
            elevation: 1,
            color: newColor,
            // color: isDark ? color : blackColor,
            child: ItemCliente(
              row: clienteSeleccionado,
              action: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ordenNotifier.setClienteSeleccionado(const ClienteEntity());
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  final SearchController _controller = SearchController();

  @override
  Widget build(BuildContext context) {
    _addListener();
    final ordenNotifier = ref.read(ordenServicioViewProvider.notifier);
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    final blackColor = Theme.of(context).colorScheme.surfaceContainerLow;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final newColor = isDark ? color : blackColor;

    return SearchAnchor.bar(
      barBackgroundColor: WidgetStatePropertyAll(newColor),
      barElevation: const WidgetStatePropertyAll(2),
      barShape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      searchController: _controller,
      barHintText: 'Buscar cliente',
      viewHintText: 'Buscar cliente',
      suggestionsBuilder: (context, controller) {
        final value = controller.value.text.normalizeSpaces();
        final clientesFiltrados = ordenNotifier.setFilter(value);

        final data = clientesFiltrados
            .map(
              (cliente) => InkWell(
                onTap: () {
                  ordenNotifier.setClienteSeleccionado(cliente);
                  _controller.closeView(cliente.fullName);
                },
                child: ItemCliente(
                  row: cliente,
                  showActions: false,
                ),
              ),
            )
            .toList();
        if (data.isEmpty) {
          return [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  children: [
                    const Text('No se encontraron clientes'),
                    ElevatedButton(
                      onPressed: () async {
                        final cliente = ordenNotifier.getCliente(value);
                        await showCreateDialog(cliente);
                        await ordenNotifier.getClientes();
                        _controller.closeView(value);
                        _controller.openView();
                      },
                      child: const Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          Text('Crear cliente'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        }
        return data;
      },
      // decoration: const InputDecoration(
      //   labelText: 'Buscar cliente',
      //   prefixIcon: Icon(Icons.search),
      //   border: OutlineInputBorder(),
      // ),
    );
  }

  void _addListener() {
    ref.listen(
      ordenServicioViewProvider.select((value) => value.orden),
      (previous, next) {
        if (!next.hasCliente && previous!.hasCliente) {
          _controller.clear();
        }
      },
    );
  }

  Future<String?> showCreateDialog(ClienteEntity? cliente) {
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return CreateClienteDialog(cliente: cliente);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientesView extends ConsumerStatefulWidget {
  const ClientesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClientesViewState();
}

class _ClientesViewState extends ConsumerState<ClientesView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Clientes'),
    );
  }
}

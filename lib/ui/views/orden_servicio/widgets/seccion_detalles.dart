import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeccionDetalles extends ConsumerWidget {
  const SeccionDetalles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    return const Scaffold(
      body: Center(
        child: Text('SeccionDetalles'),
      ),
    );
  }
}
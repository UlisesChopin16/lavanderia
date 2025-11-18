import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'seccion_abono.dart';
import 'seccion_more_info.dart';

class Header extends ConsumerStatefulWidget {
  const Header({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SeccionAbono(), SeccionMoreInfo()],
      ),
    );
  }
}

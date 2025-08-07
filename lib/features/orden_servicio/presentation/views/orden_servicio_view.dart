import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/app/routes/app_routes.dart';
import 'package:lavanderia/core/utils/printer.dart';

class OrdenServicioView extends ConsumerStatefulWidget {
  const OrdenServicioView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdenServicioViewState();
}

class _OrdenServicioViewState extends ConsumerState<OrdenServicioView> {

  @override
  Widget build(BuildContext context) {
    // final navigatorRoute = Navigator.of(context);
    // final parentRoute = ModalRoute.of(context);
    final goRoute = GoRouter.of(context);

    final canPop = goRoute.canPop();
    Printer.i('Can pop R2: $canPop,');
    // // final
    // final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    // // final (variable) = ref.watch(provider.select((value) => (value.variable)));
    
    // // Widget? leading;

    // Printer.i(
    //     'Can pop: ${parentRoute?.canPop}, useCloseButton: $useCloseButton, parentRoute: $parentRoute');
    // Printer.i('Can pop: ${navigatorRoute.canPop()}, navigatorRoute: $navigatorRoute');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden de Servicio'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Acción al presionar el botón
            context.push(AppRoutes.home);
          },
          child: Text(
            'Aquí va el contenido de la Orden de Servicio',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
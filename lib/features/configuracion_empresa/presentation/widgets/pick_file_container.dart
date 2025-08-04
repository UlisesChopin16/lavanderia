import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';

class PickFileContainer extends ConsumerStatefulWidget {
  final double height;
  final double width;
  const PickFileContainer({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  ConsumerState<PickFileContainer> createState() => _PickFileContainerState();
}

class _PickFileContainerState extends ConsumerState<PickFileContainer> {
  double get height => widget.height;
  double get width => widget.width;

  bool isHovered = false;
  bool childDesappear = false;

  static const child = Center(
    child: Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file,
          size: 80,
        ),
        Text(
          'Subir Logo',
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );

  final radius = BorderRadius.circular(15);

  @override
  Widget build(BuildContext context) {
    final surfaceContainer = Theme.of(context).colorScheme.surfaceBright;
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final logo = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => value.configuracionEmpresa.logo,
      ),
    );

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          childDesappear = false;
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          childDesappear = true;
          isHovered = false;
        });
      },
      child: InkWell(
        onTap: () {
          configuracionNotifier.setLogo();
        },
        mouseCursor: SystemMouseCursors.click,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: surfaceContainer,
                borderRadius: radius,
                image: DecorationImage(
                  image: FileImage(
                    File(logo),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              height: height,
              width: width,
              child: logo.isEmpty
                  ? childDesappear
                      ? child
                      : null
                  : null,
            ),
            ClipRRect(
              borderRadius: radius,
              child: AnimatedOpacity(
                opacity: isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.black.withOpacity(
                    0.8,
                  ),
                  height: height,
                  width: width,
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

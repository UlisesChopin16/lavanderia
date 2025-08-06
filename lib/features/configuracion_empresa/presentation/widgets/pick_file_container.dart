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

  Widget get child {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final titleMedium = Theme.of(context).textTheme.titleMedium;

    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload_file,
            color: primaryColor,
            size: 80,
          ),
          Text(
            'Subir Logo',
            style: titleMedium?.copyWith(color: primaryColor),
          ),
        ],
      ),
    );
  }

  final radius = BorderRadius.circular(15);

  @override
  Widget build(BuildContext context) {
    final surfaceBrightness = Theme.of(context).colorScheme.surfaceBright;
    final surfaceContainer = Theme.of(context).colorScheme.surfaceContainer;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorContainer = isDark ? surfaceBrightness : surfaceContainer;
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final logo = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => value.configuracionEmpresa.logo,
      ),
    );

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          childDesappear = true;
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          childDesappear = false;
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
                color: colorContainer,
                borderRadius: radius,
                image: logo.isEmpty
                    ? null
                    : DecorationImage(
                        image: FileImage(
                          File(logo),
                        ),
                        fit: BoxFit.contain,
                      ),
              ),
              height: height,
              width: width,
              child: logo.isEmpty
                  ? !childDesappear
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

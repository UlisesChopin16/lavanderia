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

  @override
  Widget build(BuildContext context) {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
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
              color: Colors.red,
              height: height,
              width: width,
            ),
            AnimatedOpacity(
              opacity: isHovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.black.withValues(
                  alpha: 170,
                ),
                height: height,
                width: width,
                child: const Center(
                  child: Icon(
                    Icons.upload_file,
                    size: 80,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

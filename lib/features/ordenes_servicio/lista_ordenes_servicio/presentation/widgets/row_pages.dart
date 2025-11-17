import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/view/view_model/lista_ordenes_view_model.dart';
import 'package:lavanderia/shared/widgets/animating_component.dart';

class RowPages extends ConsumerStatefulWidget {
  const RowPages({super.key});

  @override
  ConsumerState<RowPages> createState() => _RowPagesState();
}

class _RowPagesState extends ConsumerState<RowPages> {
  @override
  Widget build(BuildContext context) {
    final (inicio, fin, pages, totalItems) = ref.watch(
      listaOrdenesViewModelProvider.select(
        (value) => (value.inicioItems, value.finItems, value.totalPages, value.totalItems),
      ),
    );
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primary = isDark ? onPrimaryColor : primaryColor;
    final onPrimary = isDark ? primaryColor : onPrimaryColor;
    final isZero = inicio == 0;
    final isLast = fin == totalItems;

    // if (pages <= 1) {
    //   return const SizedBox.shrink();
    // }

    return AnimatingComponent(
      showComponent: totalItems > 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 5,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: onPrimaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'Mostrando ${inicio + 1} - $fin de $totalItems',
              style: TextStyle(fontSize: 12, color: primaryColor),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton.small(
                onPressed: isZero ? null : () {},
                backgroundColor: primary,
                foregroundColor: onPrimary,
                child: const Icon(Icons.chevron_left_rounded),
              ),
              const RowButtons(),
              FloatingActionButton.small(
                onPressed: isLast ? null : () {},
                backgroundColor: primary,
                foregroundColor: onPrimary,
                child: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RowButtons extends ConsumerStatefulWidget {
  const RowButtons({super.key});

  @override
  ConsumerState<RowButtons> createState() => _RowButtonsState();
}

class _RowButtonsState extends ConsumerState<RowButtons> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ordenesNotifier = ref.read(listaOrdenesViewModelProvider.notifier);
    final (pages, currentPage) = ref.watch(
      listaOrdenesViewModelProvider.select(
        (value) => (value.totalPages, value.currentPage),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 200,
        ),
        child: Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  ...List.generate(pages, (index) {
                    final newIndex = index + 1;
                    final isInCurrent = newIndex == currentPage;
                    final color = getColor(isInCurrent, context);
                    final inverseColor = getColor(!isInCurrent, context);
                    return FloatingActionButton.small(
                      onPressed: () => ordenesNotifier.changePage(newIndex),
                      backgroundColor: color,
                      child: Text(
                        '$newIndex',
                        style: TextStyle(
                          color: inverseColor,
                          fontSize: isInCurrent ? 16 : 14,
                          fontWeight: isInCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getColor(bool inverse, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return inverse ? primary : onPrimary;
  }
}

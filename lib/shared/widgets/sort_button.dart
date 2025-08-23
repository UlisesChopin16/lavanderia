import 'package:flutter/material.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';

class SortButton extends StatelessWidget {
  final bool isAscending;
  final VoidCallback? onSortChange;
  const SortButton({super.key, required this.isAscending, this.onSortChange});

  IconData get iconData => isAscending ? IconsManager.orderAZ : IconsManager.orderZA;
  String get tooltip => isAscending ? 'Ascendente' : 'Descendente';

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onSortChange,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      // icon: const Icon(Icons.add),
      // label: Text(widget.titleAddButton),
      // iconAlignment: IconAlignment.start,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData),
          Flexible(child: Text(tooltip)),
        ],
      ),
    );
  }
}

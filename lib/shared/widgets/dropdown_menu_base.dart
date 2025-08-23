import 'package:flutter/material.dart';

class DropdownMenuBase<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T>> items;
  final T? value;
  final TextEditingController controller;
  final ValueChanged<T?> onChanged;
  final Widget? leadingIcon;
  final String? label;
  final bool enableSearch;

  const DropdownMenuBase({
    super.key,
    required this.items,
    required this.onChanged,
    required this.controller,
    this.value,
    this.leadingIcon,
    this.label,
    this.enableSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      enableSearch: enableSearch,
      requestFocusOnTap: enableSearch,
      controller: controller,
      leadingIcon: leadingIcon,
      label: label != null ? Text(label!) : null,
      onSelected: onChanged,
      dropdownMenuEntries: _buildDropdownMenuEntries(context),
    );
  }

  List<DropdownMenuEntry<T>> _buildDropdownMenuEntries(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    return items.map((item) {
      final isTheSame = item.value == value;
      final trailingIcon = isTheSame ? const Icon(Icons.check_rounded) : null;
      return DropdownMenuEntry<T>(
        value: item.value,
        label: item.label,
        enabled: item.enabled,
        labelWidget: item.labelWidget,
        leadingIcon: item.leadingIcon,
        trailingIcon: trailingIcon,
        style: ButtonStyle(
          backgroundColor: isTheSame ? WidgetStateProperty.all(primaryColor) : null,
          foregroundColor: isTheSame ? WidgetStateProperty.all(onPrimaryColor) : null,
          iconColor: isTheSame ? WidgetStateProperty.all(onPrimaryColor) : null,
        ),
      );
    }).toList();
  }
}

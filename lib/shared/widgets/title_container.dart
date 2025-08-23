import 'package:flutter/material.dart';

class TitleContainer extends StatelessWidget {
  final String title;
  final IconData? icon;
  const TitleContainer({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final titleTheme = Theme.of(context).textTheme.titleMedium;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: primaryColor),
          Flexible(
            child: Text(
              title,
              style: titleTheme?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CardPadding extends StatelessWidget {
  final Color? color;
  final Widget child;
  const CardPadding({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
    );
  }
}

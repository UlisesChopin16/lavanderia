import 'package:flutter/material.dart';

class BlockProgress extends StatelessWidget {
  const BlockProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(
        alpha: 128,
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
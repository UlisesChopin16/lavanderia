import 'package:flutter/material.dart';

class AnimatingLoading extends StatefulWidget {
  final bool isLoading;
  final Widget child;
  const AnimatingLoading({super.key, required this.isLoading, required this.child});

  @override
  State<AnimatingLoading> createState() => _AnimatingLoadingState();
}

class _AnimatingLoadingState extends State<AnimatingLoading> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: widget.isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: const Center(
        child: CircularProgressIndicator(),
      ),
      secondChild: widget.child,
    );
  }
}
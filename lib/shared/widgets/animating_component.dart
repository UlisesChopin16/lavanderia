import 'package:flutter/material.dart';

class AnimatingComponent extends StatefulWidget {
  final Widget child;
  final bool showComponent;
  const AnimatingComponent({super.key, required this.child, required this.showComponent});

  @override
  State<AnimatingComponent> createState() => _AnimatingComponentState();
}

const duration = Duration(milliseconds: 300);

class _AnimatingComponentState extends State<AnimatingComponent> {
  bool get showComponent => widget.showComponent;
  late bool isVisible = showComponent;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (showComponent) {
  //       toggleVisibility(showComponent);
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showComponent) {
        toggleVisibility();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatingComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (showComponent) {
      toggleVisibility();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: duration,
      crossFadeState: isVisible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: const SizedBox.shrink(),
      secondChild: AnimatedOpacity(
        duration: duration,
        opacity: showComponent ? 1.0 : 0.0,
        onEnd: () {
          toggleVisibility();
        },
        child: AnimatedSlide(
          duration: duration,
          offset: showComponent ? Offset.zero : const Offset(1.0, 0.0),
          child: IgnorePointer(
            ignoring: !showComponent,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  void toggleVisibility() {
    setState(() {
      isVisible = showComponent;
    });
  }
}

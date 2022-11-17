import 'package:flutter/material.dart';

import '../transitions/constants.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  const AnimatedFloatingActionButton({ super.key, required this.animation, this.onPressed, this.child });

  final Animation<double> animation;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  State<AnimatedFloatingActionButton> createState() => _AnimatedFloatingActionButton();

}

class _AnimatedFloatingActionButton extends State<AnimatedFloatingActionButton> {
  late Animation<double> scaleAnimation;
  late Animation<ShapeBorder?> shapeAnimation;

  @override
  void initState() {
    super.initState();

    scaleAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: const Interval(
        750 / transitionLength, 1000 / transitionLength,
        curve: Curves.easeInOutCubicEmphasized
      ),
      reverseCurve: Interval(
        0, 250 / transitionLength,
        curve: Curves.easeInOutCubicEmphasized.flipped,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: scaleAnimation,
      child: FloatingActionButton(
        backgroundColor: colorScheme.tertiaryContainer,
        foregroundColor: colorScheme.onTertiaryContainer,
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}

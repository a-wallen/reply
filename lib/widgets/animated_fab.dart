import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  const AnimatedFloatingActionButton({ super.key, required this.animation, this.onPressed, this.elevation, this.child });

  final Animation<double> animation;
  final VoidCallback? onPressed;
  final Widget? child;
  final double? elevation;

  @override
  State<AnimatedFloatingActionButton> createState() => _AnimatedFloatingActionButton();

}

class _AnimatedFloatingActionButton extends State<AnimatedFloatingActionButton> {
  late Animation<double> scaleAnimation;
  late Animation<double> shapeAnimation;

  @override
  void initState() {
    super.initState();

    scaleAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: const Interval(
        3 / 5, 4 / 5,
        curve: Curves.easeInOutCubicEmphasized
      ),
      reverseCurve: Interval(
        3 / 5, 1,
        curve: Curves.easeInOutCubicEmphasized.flipped,
      ),
    );

    shapeAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: const Interval(
        2 / 5, 3 / 5,
        curve: Curves.easeInOutCubicEmphasized
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: scaleAnimation,
      child: FloatingActionButton(
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(lerpDouble(30, 15, shapeAnimation.value)!),
            )
        ),
        backgroundColor: colorScheme.tertiaryContainer,
        foregroundColor: colorScheme.onTertiaryContainer,
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}

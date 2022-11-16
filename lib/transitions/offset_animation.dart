import 'constants.dart';
import 'package:flutter/animation.dart';

class OffsetAnimation extends CurvedAnimation {
  OffsetAnimation(Animation<double> parent) : super(
    parent: parent,
    curve: const Interval(
      500 / transitionLength, 1.0,
      curve: Curves.easeInOutCubicEmphasized,
    ),
    reverseCurve: Interval(
      0, 250 / transitionLength,
      curve: Curves.easeInOutCubicEmphasized.flipped,
    ),
  );
}

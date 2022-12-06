import 'package:flutter/animation.dart';

class OffsetAnimation extends CurvedAnimation {
  OffsetAnimation(Animation<double> parent) : super(
    parent: parent,
    curve: const Interval(
      2 / 5,
      1,
      curve: Curves.easeInOutCubicEmphasized,
    ),
    reverseCurve: Interval(
      0,
      1 / 5,
      curve: Curves.easeInOutCubicEmphasized.flipped,
    ),
  );
}

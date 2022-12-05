import 'package:flutter/animation.dart';

class SizeAnimation extends CurvedAnimation {
  SizeAnimation(Animation<double> parent) : super(
    parent: parent,
    curve: const Interval(
      1 / 5,
      4 / 5,
      curve: Curves.easeInOutCubicEmphasized,
    ),
    reverseCurve: Interval(
      0,
      1 / 5,
      curve: Curves.easeInOutCubicEmphasized.flipped,
    ),
  );
}

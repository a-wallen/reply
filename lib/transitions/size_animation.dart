import 'package:flutter/animation.dart';
import 'package:reply/transitions/constants.dart';

class SizeAnimation extends CurvedAnimation {
  SizeAnimation(Animation<double> parent) : super(
    parent: parent,
    curve: const Interval(
      250 / transitionLength / 2, 1000 / transitionLength,
      curve: Curves.easeInOutCubicEmphasized,
    ),
    reverseCurve: Interval(
      0, 250 / transitionLength,
      curve: Curves.easeInOutCubicEmphasized.flipped,
    ),
  );
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:reply/transitions/offset_animation.dart';
import 'package:reply/transitions/size_animation.dart';

class OneTwoTransition extends StatefulWidget {
  const OneTwoTransition({
    super.key,
    required this.animation,
    required this.one,
    required this.two,
  });

  final Animation<double> animation;
  final Widget one;
  final Widget two;

  @override
  State<OneTwoTransition> createState() => _OneTwoTransitionState();
}

class _OneTwoTransitionState extends State<OneTwoTransition> {
  late final Animation<Offset> offsetAnimation;
  late Animation<double> widthAnimation = const AlwaysStoppedAnimation(0);
  late Animation<double> sizeAnimation = SizeAnimation(widget.animation);

  double currentFlexFactor = 0;

  @override
  void initState() {
    super.initState();

    offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(OffsetAnimation(sizeAnimation));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // When the app's width is < 800, widgets one and two get 1/2 of
    // the available width, As the app gets wider, the allocation
    // gradually changes to 1/3 and 2/3 for widgets one and two. When
    // the window is wider than 1600, the allocation changes to 1/4  3/4.
    final double width = MediaQuery.of(context).size.width;
    double nextFlexFactor = 1000;
    if (width >= 800 && width < 1200) {
      nextFlexFactor = lerpDouble(1000, 2000, (width - 800) / 400)!;
    } else if (width >= 1200 && width < 1600) {
      nextFlexFactor = lerpDouble(2000, 3000, (width - 1200) / 400)!;
    } else if (width > 1600) {
      nextFlexFactor = 3000;
    }

    if(nextFlexFactor == currentFlexFactor) {
      return;
    }

    if(currentFlexFactor == 0) {
      widthAnimation = Tween<double>(
        begin: 0,
        end: nextFlexFactor
      ).animate(sizeAnimation);
    }


    final TweenSequence<double> sequence = TweenSequence([
      if(sizeAnimation.value > 0) ...[
        TweenSequenceItem(
          tween: Tween(begin: 0, end: widthAnimation.value),
          weight: sizeAnimation.value,
        ),
      ],
      if(sizeAnimation.value < 1) ...[
        TweenSequenceItem(
          tween: Tween(begin: widthAnimation.value, end: nextFlexFactor),
          weight: 1 - sizeAnimation.value,
        ),
      ],
    ]);

    widthAnimation = sequence.animate(sizeAnimation);
    currentFlexFactor = nextFlexFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1000,
          child: widget.one,
        ),
        if(widthAnimation.value.toInt() > 0) ...[
          Flexible(
            flex: widthAnimation.value.toInt(),
            child: FractionalTranslation(
              translation: offsetAnimation.value,
              child: widget.two,
            ),
          ),
        ],
      ],
    );
  }
}

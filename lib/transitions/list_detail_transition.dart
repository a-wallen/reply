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
  late Animation<double> widthAnimation;


  @override
  void initState() {
    super.initState();

    offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(OffsetAnimation(widget.animation));
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // When the app's width is < 800, widgets one and two get 1/2 of
    // the available width, As the app gets wider, the allocation
    // gradually changes to 1/3 and 2/3 for widgets one and two. When
    // the window is wider than 1600, the allocation changes to 1/4  3/4.
    final double width = MediaQuery.of(context).size.width;
    double end = 1000;
    if (width >= 800 && width < 1200) {
      end = lerpDouble(1000, 2000, (width - 800) / 400)!;
    } else if (width >= 1200 && width < 1600) {
      end = lerpDouble(2000, 3000, (width - 1200) / 400)!;
    } else if (width > 1600) {
      end = 3000;
    }
    widthAnimation = Tween<double>(
      begin: 0,
      end: end,
    ).animate(SizeAnimation(widget.animation));
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
          const Padding(padding: EdgeInsets.only(right: 8.0)),
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

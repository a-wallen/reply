import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  const StarButton({super.key});

  @override
  State<StarButton> createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  bool state = false;

  Icon get icon {
    final Color color = state
      ? Colors.yellow
      : Colors.grey;

    final IconData iconData = state
      ? Icons.star
      : Icons.star_outline;

    return Icon(
      iconData,
      color: color,
      size: 20,
    );
  }

  void toggle() {
    setState(() {
      state = !state;
    });
  }

  double get turns => state ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 300),
      child: FloatingActionButton(
        elevation: 0,
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        onPressed: () => setState(() => state = !state),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: icon,
        ),
      ),
    );
  }
}

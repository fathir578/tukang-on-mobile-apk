import 'package:flutter/material.dart';

class FadeSlideTransition extends StatelessWidget {
  final Widget child;
  final int index;
  const FadeSlideTransition({super.key, required this.child, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300 + index * 100),
      child: child,
    );
  }
}

/// Source: [https://github.com/jogboms/flutter_spinkit].
/// Copy at: 13/7/2023.
/// MIT License.

import 'dart:math' as math show sin, pi;

import 'package:flutter/animation.dart';

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay}) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
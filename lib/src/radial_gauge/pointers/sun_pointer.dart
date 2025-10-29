import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class SunPointer extends Equatable implements GaugePointer {
  const SunPointer({
    required this.radius,
    this.pointerValue = 0,
    this.color,
    this.position = const GaugePointerPosition.surface(),
    this.border,
    this.gradient = const RadialGradient(
      colors: [
        Color(0xFFFFEE58),
        Color(0xFFFFD54F),
        Color(0xFFFFA726),
        Color(0xFFFF7043),
      ],
      radius: 0.8,
    ),
    this.shadow,
  });
  final double radius;
  final double pointerValue;

  @override
  final GaugePointerPosition position;
  @override
  final Color? color;
  @override
  final GaugePointerBorder? border;
  @override
  final Gradient? gradient;
  @override
  final Shadow? shadow;

  @override
  Size get size => Size.square(radius * 2);

  @override
  Path get path {
    final path = Path();
    final center = size.width / 2;
    final centerOffset = Offset(center, center);

    const rayCount = 8; // number of rays
    final innerR = radius; // sun core
    final outerR = radius * 1.6; // ray tip distance

    // Draw the rays
    for (var i = 0; i < rayCount; i++) {
      final angle = (2 * math.pi / rayCount) * i;
      final nextAngle = angle + (math.pi / rayCount);

      final x1 = center + innerR * math.cos(angle);
      final y1 = center + innerR * math.sin(angle);
      final x2 = center + outerR * math.cos(angle + (math.pi / rayCount / 2));
      final y2 = center + outerR * math.sin(angle + (math.pi / rayCount / 2));
      final x3 = center + innerR * math.cos(nextAngle);
      final y3 = center + innerR * math.sin(nextAngle);

      path.moveTo(x1, y1);
      path.lineTo(x2, y2);
      path.lineTo(x3, y3);
      path.close();
    }

    // Add the center circle
    path.addOval(Rect.fromCircle(center: centerOffset, radius: innerR * 0.7));

    return path;
  }

  @override
  double get value => pointerValue;

  @override
  List<Object?> get props => [
        size,
        color,
        border,
        position,
        gradient,
        shadow,
        pointerValue,
      ];
}

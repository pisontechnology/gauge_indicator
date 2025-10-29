import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class MoonPointer extends Equatable implements GaugePointer {
  const MoonPointer({
    required this.radius,
    this.pointerValue = 0,
    this.color,
    this.position = const GaugePointerPosition.surface(),
    this.border,
    this.gradient = const RadialGradient(
      colors: [
        Color(0xFFFFFDEB),
        Color(0xFFFFF8D1),
        Color(0xFFFFE6A3),
        Color(0xFFFFC68F),
      ],
      center: Alignment.topRight,
      radius: 0.8,
    ),
    this.shadow,
    this.rotation = 180,
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

  /// Rotation in degrees
  final double rotation;

  @override
  Size get size => Size.square(radius);

  @override
  Path get path {
    final center = size.width / 2;
    final centerOffset = Offset(center, center);

    // Base full moon
    final base = Path()
      ..addOval(Rect.fromCircle(center: centerOffset, radius: radius));

    // Cutout circle (shadow faces up-right)
    final offset = Offset(-radius * 0.6, radius * 0.4);
    final cutout = Path()
      ..addOval(Rect.fromCircle(center: centerOffset + offset, radius: radius));

    // Create crescent by subtracting paths
    final crescent = Path.combine(PathOperation.difference, base, cutout);

    // Rotate crescent
    final cosA = math.cos(rotation);
    final sinA = math.sin(rotation);

    final matrix = Float64List.fromList([
      cosA,
      sinA,
      0,
      0,
      -sinA,
      cosA,
      0,
      0,
      0,
      0,
      1,
      0,
      center - center * cosA + center * sinA,
      center - center * cosA - center * sinA,
      0,
      1,
    ]);

    return crescent.transform(matrix);
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
    rotation,
  ];
}

import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class MoonPointer extends Equatable implements GaugePointer {
  const MoonPointer({
    required this.radius,
    required this.pointerValue,
    this.color = const Color(0xFFFECB03),
    this.position = const GaugePointerPosition.surface(),
    this.border,
    this.gradient,
    this.shadow,
    this.rotation = math.pi * 2, // Default to 360 degrees in radians
  });

  /// The radius of the moon shape. The total size will be Size.
  /// square(radius * 2).
  final double radius;

  // Value from 0.0 (New Moon) to 1.0 (Full Moon/New Moon)
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

  /// Rotation in radians (e.g., math.pi for 180 degrees).
  final double rotation;

  @override
  Size get size => Size.square(radius * 2); // Size is diameter, not radius

  @override
  Path get path {
    final diameter = size.width;
    final center = diameter / 2;
    final centerOffset = Offset(center, center);

    // Base moon (full circle)
    final base = Path()
      ..addOval(Rect.fromCircle(center: centerOffset, radius: radius));

    // The cutout circle's center is shifted horizontally.
    // Start the cutout slightly to the right of the base circle's center.
    final cutoutCenter = Offset(centerOffset.dx + radius - 2, centerOffset.dy);

    // The cutout circle is the same size as the base circle.
    final cutout = Path()
      ..addOval(Rect.fromCircle(center: cutoutCenter, radius: radius));

    // Create crescent by subtracting paths (Difference = base - cutout)
    final crescent = Path.combine(PathOperation.difference, base, cutout);

    // Apply rotation around the center (centerOffset)
    final angle = rotation;

    final transformMatrix = Matrix4.identity()
      ..translateByDouble(centerOffset.dx, centerOffset.dy, 0, 1)
      ..rotateZ(angle)
      ..translateByDouble(-centerOffset.dx, -centerOffset.dy, 0, 1);

    // Only apply the rotation if it's not the default 0 rotation
    return crescent.transform(transformMatrix.storage);
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

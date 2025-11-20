import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class SunPointer extends Equatable implements GaugePointer {
  const SunPointer({
    required this.radius,
    this.pointerValue = 0,
    this.color = const Color(0xFFFECB03),
    this.position = const GaugePointerPosition.surface(),
    this.border,
    this.gradient,
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

  // Size is now the diameter for proper centering (radius * 2)
  // but since the original used `radius`, we'll stick to that
  // and assume the sun is centered in a square of size `radius x radius`.
  @override
  Size get size => Size.square(radius * 2);

  @override
  Path get path {
    final finalPath = Path();

    // The sun is drawn centered at Offset.zero (the origin)
    // within the Path's local coordinate system.
    const sunCenter = Offset.zero;

    // Center circle
    finalPath.addOval(Rect.fromCircle(center: sunCenter, radius: radius * 0.6));

    // Ray count
    const rayCount = 16;

    // Ray sizes relative to radius
    final longEnd = radius + 1.6;
    final longStart = radius * 0.8;
    final shortEnd = radius;
    final shortStart = radius * 0.8;

    for (var i = 0; i < rayCount; i++) {
      final isLong = i.isEven;

      // Length and position calculations
      final start = isLong ? longStart : shortStart;
      final end = isLong ? longEnd : shortEnd;
      final length = end - start;
      final midPosition = (start + end) / 2;

      // Thickness and rounded corners
      final rayWidth = radius * 0.1;
      final rayRadius = rayWidth / 3;

      // Angle for rotation (in radians)
      const rayApartDegrees = 360 / rayCount; // 22.5 degrees
      final angleRadians = i * rayApartDegrees * math.pi / 180;

      // 1. Define the rectangular ray at the origin, centered on the X-axis
      // It must be defined as a vertical rectangle to be rotated correctly
      // to the angle
      // Width is the thickness, Height is the length.
      final rayRect = Rect.fromCenter(
        center: Offset(midPosition, 0), // Positioned along the X-axis
        width: length, // The length of the ray (along X-axis)
        height: rayWidth, // The thickness of the ray (along Y-axis)
      );

      final rrect = RRect.fromRectAndRadius(
        rayRect,
        Radius.circular(rayRadius),
      );

      // 2. Create the Path for the ray
      final rayPath = Path()..addRRect(rrect);

      // 3. Apply the rotation transformation
      // The matrix rotates the ray around the origin (sunCenter)
      final matrix = Matrix4.identity();

      // To properly rotate a ray that is horizontally aligned
      // (length on X-axis)
      // we only need to rotate around the Z-axis (which is the rotation in 2D).
      matrix.rotateZ(angleRadians);

      // 4. Add the transformed ray to the final path
      finalPath.addPath(rayPath.transform(matrix.storage), sunCenter);
    }
    return finalPath;
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

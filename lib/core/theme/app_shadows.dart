import 'package:flutter/material.dart';

class AppShadows {
  static final BoxShadow light = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );

  static final BoxShadow medium = BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow glow(Color color, {double opacity = 0.05}) => BoxShadow(
    color: color.withOpacity(opacity),
    blurRadius: 20,
    offset: const Offset(0, 10),
  );
}

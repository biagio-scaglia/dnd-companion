import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;

  // EdgeInsets helpers
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllS = EdgeInsets.all(s);
  static const EdgeInsets paddingAllM = EdgeInsets.all(m);
  static const EdgeInsets paddingAllL = EdgeInsets.all(l);

  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: m);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: m);
  
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: l);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: l);
}

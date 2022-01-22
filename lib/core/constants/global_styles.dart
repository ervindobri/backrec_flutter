import 'dart:ui';

import 'package:flutter/material.dart';

import 'global_colors.dart';

class GlobalStyles {
  static BorderRadius radiusAll12 = BorderRadius.circular(12);
  static BorderRadius radiusAll16 = BorderRadius.circular(16);
  static BorderRadius radiusAll24 = BorderRadius.circular(24);
  static ImageFilter blur = ImageFilter.blur(sigmaX: 10, sigmaY: 10);
  static ImageFilter highBlur = ImageFilter.blur(sigmaX: 30, sigmaY: 30);

  static var redShadow = [
    BoxShadow(color: GlobalColors.primaryRed.withOpacity(.15), blurRadius: 24)
  ];

  static BorderRadius topRadius24 = BorderRadius.vertical(top: Radius.circular(24));

  static ButtonStyle buttonStyle({Color color = GlobalColors.primaryRed}) =>
      ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: radiusAll12)),
        backgroundColor: MaterialStateProperty.all(color),
      );

  static teamDecoration() {}

  static whiteBorder() => Border.all(
        color: Colors.white,
        width: 3,
      );
}

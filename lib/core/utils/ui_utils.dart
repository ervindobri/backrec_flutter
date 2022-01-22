import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

class UiUtils {
  static void showToast(String title) {
    Fluttertoast.showToast(
      backgroundColor: GlobalColors.primaryRed,
      gravity: ToastGravity.CENTER,
      msg: title,
      textColor: Colors.white,
    );
  }

  static void vibrate({int duration = 50}) {
    Vibration.vibrate(duration: duration);
  }
}

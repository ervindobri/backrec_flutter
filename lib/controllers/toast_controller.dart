import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ToastController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void showToast(String title, Icon icon) {
    Fluttertoast.showToast(
      backgroundColor: GlobalColors.primaryRed,
      gravity: ToastGravity.BOTTOM,
      msg: title,
      textColor: Colors.white,
    );
  }
}

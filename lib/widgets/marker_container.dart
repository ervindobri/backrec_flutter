import 'dart:ui';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarkerContainer extends StatelessWidget {
  final Widget content;
  const MarkerContainer({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: Get.width / 3,
          width: Get.width / 3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: GlobalColors.primaryGrey.withOpacity(.6),
              border:
                  Border.all(color: Colors.white.withOpacity(.6), width: 5)),
          child: content,
        ),
      ),
    );
  }
}

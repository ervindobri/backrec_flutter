import 'package:flutter/material.dart';

class NavUtils {
  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  static void to(BuildContext context, Widget page) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                page));
  }
}

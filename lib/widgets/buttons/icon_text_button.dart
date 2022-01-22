import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const IconTextButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(icon, color: textColor, size: 16),
                ),
                Text(
                  text,
                  style: context.bodyText1.copyWith(color: textColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

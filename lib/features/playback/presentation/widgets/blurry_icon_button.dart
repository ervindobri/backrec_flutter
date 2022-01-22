import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:flutter/material.dart';

class BlurryIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final TextDecoration? decoration;
  final Color color;
  const BlurryIconButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      required this.icon,
      this.decoration = TextDecoration.none, this.color = GlobalColors.primaryGrey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: GlobalStyles.radiusAll12,
      child: BackdropFilter(
        filter: GlobalStyles.blur,
        child: Container(
          height: 50,
          child: TextButton.icon(
            style: ButtonStyle(
              padding:
                  MaterialStateProperty.all(EdgeInsets.fromLTRB(8, 4, 16, 4)),
              backgroundColor: MaterialStateProperty.all(
                  color.withOpacity(.6)),
            ),
            onPressed: () {
              print("new marker");
              onPressed();
            },
            icon: Icon(icon, color: Colors.white),
            label: Text(
              label,
              style: context.bodyText1
                  .copyWith(color: Colors.white, decoration: decoration),
            ),
          ),
        ),
      ),
    );
  }
}

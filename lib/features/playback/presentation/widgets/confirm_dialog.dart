import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  const ConfirmationDialog({Key? key, this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: GlobalColors.primaryGrey,
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          color: GlobalColors.primaryGrey.withOpacity(.4),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: ClipRRect(
          child: BackdropFilter(
            filter: GlobalStyles.blur,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Are you sure you want to delete video?",
                    textAlign: TextAlign.center,
                    style: context.headline6.copyWith(color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: Icon(FeatherIcons.xCircle,
                          color: GlobalColors.primaryRed),
                      label: Text('Cancel',
                          style: context.bodyText1
                              .copyWith(color: GlobalColors.primaryRed)),
                      onPressed: () {
                        NavUtils.back(context);
                      },
                    ),
                    TextButton.icon(
                      style: GlobalStyles.buttonStyle(),
                      icon: Icon(
                        FeatherIcons.trash,
                        color: Colors.white,
                      ),
                      label: Text('Confirm',
                          style: context.bodyText1.copyWith(
                            color: Colors.white,
                          )),
                      onPressed: onConfirm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

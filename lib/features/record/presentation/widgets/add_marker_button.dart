import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/constants/global_strings.dart';
import 'package:backrec_flutter/core/constants/global_styles.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/marker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

class NewMarkerButton extends StatelessWidget {
  final Team? homeTeam, awayTeam;
  final Duration endPosition;
  final MarkerCallback? onMarkerConfigured;
  final VoidCallback onTap;
  final VoidCallback? onCancel;

  const NewMarkerButton({
    Key? key,
    // required this.controller,
    this.homeTeam,
    this.awayTeam,
    required this.endPosition,
    this.onMarkerConfigured,
    required this.onTap,
    this.onCancel,
  }) : super(key: key);

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
              backgroundColor: MaterialStateProperty.all(
                  GlobalColors.primaryGrey.withOpacity(.4)),
            ),
            onPressed: () {
              print("new marker");
              onTap();
            },
            icon: Icon(FeatherIcons.plusCircle, color: Colors.white),
            label: Text(
              GlobalStrings.marker,
              style: Get.textTheme.bodyText1!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

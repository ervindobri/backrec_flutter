import 'dart:ui';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/dialogs/marker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

class NewMarkerButton extends StatelessWidget {
  final Team homeTeam, awayTeam;
  final Duration endPosition;
  final MarkerCallback onMarkerConfigured;

  const NewMarkerButton(
      {Key? key,
      // required this.controller,
      required this.homeTeam,
      required this.awayTeam,
      required this.endPosition, 
      required this.onMarkerConfigured})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(MarkerDialog(
          endPosition: endPosition,
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          onMarkerConfigured: onMarkerConfigured,
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            // width: 55,
            height: 55,
            decoration:
                BoxDecoration(color: GlobalColors.primaryGrey.withOpacity(.4)),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(FeatherIcons.plusCircle, color: Colors.white),
                  ),
                  Text(
                    "Marker",
                    style:
                        Get.textTheme.bodyText1!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/screens/playback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VideoSelectorThumbnail extends StatelessWidget {
  const VideoSelectorThumbnail({
    Key? key,
    required ImagePicker picker,
    required this.homeTeam,
    required this.awayTeam,
  })  : _picker = picker,
        super(key: key);

  final ImagePicker _picker;
  final Team homeTeam, awayTeam;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final XFile? video =
            await _picker.pickVideo(source: ImageSource.gallery);
        print(video!.name);
        if (video.name != "") {
          Get.to(() => PlaybackScreen(
              video: video, homeTeam: homeTeam, awayTeam: awayTeam));
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: GlobalColors.primaryGrey.withOpacity(.4)),
              child: Center(
                child: Icon(FeatherIcons.file, color: Colors.white),
              )),
        ),
      ),
    );
  }
}

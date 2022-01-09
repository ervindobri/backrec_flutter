import 'dart:ui';
import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/constants/global_styles.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/features/playback/presentation/pages/playback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VideoSelectorThumbnail extends StatelessWidget {
  const VideoSelectorThumbnail({
    Key? key,
    required ImagePicker picker,
    required this.homeTeam,
    required this.awayTeam,
    required this.onTap,
  })  : _picker = picker,
        super(key: key);

  final ImagePicker _picker;
  final Team homeTeam, awayTeam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: GlobalStyles.radiusAll12,
      child: InkWell(
        onTap: () async {
          onTap();
          final XFile? video =
              await _picker.pickVideo(source: ImageSource.gallery);
          print(video!.name);
          if (video.name != "") {
            final playbackBloc = context.read<PlaybackBloc>();
            Get.to(
                () => bloc.BlocProvider(
                      create: (context) => playbackBloc
                        ..add(InitializePlaybackEvent(video, false, false)),
                      child: PlaybackScreen(
                          homeTeam: homeTeam, awayTeam: awayTeam),
                    ),
                fullscreenDialog: true,
                transition: Transition.downToUp);
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
      ),
    );
  }
}

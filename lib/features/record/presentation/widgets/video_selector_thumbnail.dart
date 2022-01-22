import 'dart:io';

import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/constants/global_styles.dart';
import 'package:backrec_flutter/core/extensions/string_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/playback/presentation/pages/playback_screen.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class VideoSelectorThumbnail extends StatelessWidget {
  const VideoSelectorThumbnail({
    Key? key,
    required ImagePicker picker,
    this.homeTeam,
    this.awayTeam,
    required this.onTap,
  })  : _picker = picker,
        super(key: key);

  final ImagePicker _picker;
  final Team? homeTeam, awayTeam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: GlobalStyles.radiusAll12,
      child: InkWell(
        onTap: () async {
          try {
            onTap();
            final result = await FilePicker.platform.pickFiles(
                type: FileType.video, allowCompression: true, withData: true);
            if (result != null && result.files.isNotEmpty) {
              PlatformFile video = result.files.first;
              print(video.name);
              if (video.name != "") {
                print(video.path);
                await sl<MarkerCubit>().loadMarkers(video.name.parsed);
                NavUtils.to(
                  context,
                  bloc.MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => sl<MarkerCubit>(),
                      ),
                      bloc.BlocProvider(
                        create: (context) => sl<PlaybackBloc>()
                          ..add(InitializePlaybackEvent(
                              video.path!, false, false)),
                      ),
                    ],
                    child:
                        PlaybackScreen(homeTeam: homeTeam, awayTeam: awayTeam),
                  ),
                );
              }
            }
          } catch (e) {
            print(e);
          }
        },
        child: ClipRRect(
          borderRadius: GlobalStyles.radiusAll12,
          child: BackdropFilter(
            filter: GlobalStyles.blur,
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

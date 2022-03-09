import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:backrec_flutter/features/playback/presentation/pages/playback_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordedVideoThumbnail extends StatelessWidget {
  final Team? homeTeam, awayTeam;
  final XFile video;
  // final List<Marker> markers;
  final VoidCallback onTap;

  const RecordedVideoThumbnail({
    Key? key,
    this.homeTeam,
    this.awayTeam,
    required this.onTap,
    // required this.markers,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        onTap();
        NavUtils.to(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<PlaybackBloc>()
                  ..add(InitializePlaybackEvent(video.path, false, true)),
              ),
              BlocProvider(
                create: (context) => sl<MarkerCubit>(),
              ),
            ],
            child: PlaybackScreen(
              homeTeam: homeTeam,
              awayTeam: awayTeam,
            ),
          ),
        );
      },
      child: Container(
        width: 89,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: BlocConsumer<PlaybackBloc, PlaybackState>(
            listener: (context, state) {
              if (state is PlaybackError) {
                print(state.message);
              }
            },
            builder: (context, state) {
              if (state is ThumbnailInitialized) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(state.thumbnail))),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: GlobalColors.primaryRed,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/record_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/features/playback/presentation/pages/playback_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class RecordedVideoThumbnail extends StatelessWidget {
  final XFile? video;
  final Team homeTeam, awayTeam;
  final List<Marker> markers;
  final VoidCallback onTap;

  const RecordedVideoThumbnail({
    Key? key,
    this.video,
    required this.homeTeam,
    required this.awayTeam,
    required this.onTap, required this.markers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return InkWell(
        onTap: () {
          onTap();
          NavUtils.to(
            context,
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<PlaybackBloc>()
                    ..add(InitializePlaybackEvent(video!, false, true)),
                ),
                BlocProvider(
                  create: (context) => sl<MarkerCubit>()..setMarkers(markers),
                ),
              ],
              child: PlaybackScreen(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
              ),
            ),
          );
        },
        child: BlocConsumer<RecordBloc, RecordState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is RecordingStopped) {
              return Container(
                width: 80,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: BlocBuilder<PlaybackBloc, PlaybackState>(
                      builder: (context, state) {
                        if (state is ThumbnailInitialized) {
                          print(state.controller);
                          return VideoPlayer(state.controller);
                        } else {
                          return CircularProgressIndicator(
                            color: GlobalColors.primaryRed,
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}

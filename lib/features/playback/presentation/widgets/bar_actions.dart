import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:backrec_flutter/core/constants/constants.dart';
import 'package:backrec_flutter/core/constants/global_strings.dart';
import 'package:backrec_flutter/core/extensions/string_ext.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/core/utils/nav_utils.dart';
import 'package:backrec_flutter/core/utils/ui_utils.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/playback/presentation/widgets/confirm_dialog.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/marker_dialog.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/team_selector_dialog.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:backrec_flutter/widgets/marker_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

typedef DurationCallback = Function(Duration);

class VideoPlayerActions extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final DurationCallback onSeek;
  final VoidCallback onJumpBackward;
  final VoidCallback onJumpForward;
  final MarkerCallback onMarkerTap;
  // final List<Marker> markers;
  final Duration totalDuration;
  final VideoPlayerController controller;
  final bool isPlaying;
  final bool inFocus;
  final Team? homeTeam;
  final Team? awayTeam;
  final TeamSelectionCallback setTeams;
  final VoidCallback onMarkerPlayback;

  const VideoPlayerActions(
      {Key? key,
      required this.onPlay,
      required this.onPause,
      required this.onJumpBackward,
      required this.onMarkerPlayback,
      required this.onJumpForward,
      // required this.markers,
      this.totalDuration = Duration.zero,
      required this.controller,
      this.isPlaying = false,
      this.inFocus = false,
      this.homeTeam,
      this.awayTeam,
      required this.onSeek,
      required this.onMarkerTap,
      required this.setTeams})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double progressBarPos = 50.0;
    final markers = context.select((MarkerCubit cubit) => cubit.markers);
    final barWidth = width - 100; // width - leftlabel, rightlabel and paddings
    return Container(
      width: width,
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //actions - prev, next marker
          Positioned(
            bottom: progressBarPos + 20,
            left: 0,
            child: Container(
              height: height * .15,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: GlobalStrings.jumpToPreviousMarkerTooltip,
                    child: IconButton(
                      onPressed: onJumpBackward,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: GlobalStyles.redShadow,
                            color: GlobalColors.primaryRed),
                        child: Center(
                          child:
                              Icon(FeatherIcons.skipBack, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: barWidth,
                    height: 50,
                    // color: Colors.black,
                    child: Stack(
                        children: markers
                            .map(
                              (e) => MarkerPin(
                                marker: e,
                                totalWidth: width - 132,
                                onMarkerTap: () {
                                  e.id = markers
                                      .indexOf(e); //set index if non existent
                                  onMarkerTap(e);
                                },
                                totalDuration: totalDuration,
                              ),
                            )
                            .toList()),
                  ),
                  Tooltip(
                    message: GlobalStrings.jumpToNextMarkerTooltip,
                    child: IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      onPressed: onJumpForward,
                      icon: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: GlobalStyles.redShadow,
                            color: GlobalColors.primaryRed),
                        child: Center(
                          child: Icon(FeatherIcons.skipForward,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
          // playback bar with markers on it,
          ,
          Positioned(
            bottom: progressBarPos,
            left: 0,
            child: Container(
              width: width,
              // color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, VideoPlayerValue value, child) {
                      return ProgressBar(
                        progress: value.position,
                        total: value.duration,
                        timeLabelLocation: TimeLabelLocation.sides,
                        timeLabelTextStyle:
                            context.bodyText1.copyWith(color: Colors.white),
                        thumbColor: Colors.white,
                        timeLabelType: TimeLabelType.remainingTime,
                        baseBarColor: GlobalColors.primaryRed.withOpacity(.2),
                        barHeight: 10,
                        progressBarColor: GlobalColors.primaryRed,
                        onSeek: (duration) {
                          onSeek(duration);
                        },
                      );
                    }),
              ),
            ),
          ),
          // bottom action and infos
          Positioned(
            bottom: 0,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: inFocus ? 0.0 : 1.0,
              child: Container(
                width: width,
                child: Stack(
                  children: [
                    //play/pause and info row
                    Row(
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: !isPlaying
                              ? IconButton(
                                  iconSize: 20,
                                  icon: Icon(FontAwesomeIcons.play,
                                      color: Colors.white),
                                  onPressed: () {
                                    onPlay();
                                  })
                              : IconButton(
                                  iconSize: 20,
                                  icon: Icon(FontAwesomeIcons.pause,
                                      color: Colors.white),
                                  onPressed: () {
                                    onPause();
                                  }),
                        ),
                        TextButton.icon(
                          icon: Icon(FeatherIcons.playCircle,
                              color: GlobalColors.primaryRed),
                          label: Text(GlobalStrings.playback,
                              style: context.bodyText1.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: GlobalColors.primaryRed)),
                          onPressed: onMarkerPlayback,
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: ValueNotifier(
                              homeTeam != null && awayTeam != null),
                          builder: (context, value, child) {
                            if (value) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Container(
                                  width: 130,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(homeTeam!.name,
                                          style: context.bodyText1
                                              .copyWith(color: Colors.white)),
                                      Text("VS",
                                          style: context.bodyText1.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                      Text(awayTeam!.name,
                                          style: context.bodyText1
                                              .copyWith(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        )
                      ],
                    ),
                    //trash - to delete video
                    Positioned(
                      right: 0,
                      child: Wrap(
                        spacing: 16,
                        children: [
                          BlocListener<MarkerCubit, MarkerState>(
                            listener: (context, state) {
                              print(state);
                              if (state is MarkerSaved) {
                                UiUtils.showToast(
                                    GlobalStrings.markersSavedToast);
                              }
                            },
                            child: TextButton.icon(
                              label: Text(GlobalStrings.saveMarkers,
                                  style: context.bodyText1
                                      .copyWith(color: Colors.white)),
                              icon: FaIcon(FontAwesomeIcons.save,
                                  size: 20, color: Colors.white),
                              onPressed: () {
                                final videoName = context
                                    .read<PlaybackRepository>()
                                    .videoNameParsed;
                                print(videoName.parsed);
                                context
                                    .read<MarkerCubit>()
                                    .saveData(videoName.parsed);
                              },
                            ),
                          ),
                          IconButton(
                            icon: FaIcon(FeatherIcons.trash,
                                size: 20, color: Colors.white),
                            onPressed: () {
                              final playbackBloc = context.read<PlaybackBloc>();
                              showDialog(
                                  context: context,
                                  useSafeArea: false,
                                  builder: (context) =>
                                      ConfirmationDialog(onConfirm: () {
                                        playbackBloc.add(DeletePlaybackEvent());
                                        NavUtils.back(context);
                                        NavUtils.toRecording(context);
                                      }));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

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
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/marker_dialog.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/team_selector_dialog.dart';
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
  final Marker? currentMarker;
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
      required this.setTeams,
      this.currentMarker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    final double progressBarPos = 32.0;
    final markers = context.select((MarkerCubit cubit) => cubit.markers);
    final notchPadding = MediaQuery.of(context).viewPadding;
    final double leftPadding = notchPadding.left > 0 ? notchPadding.left : 10.0;
    final double rightPadding =
        notchPadding.right > 0 ? notchPadding.right : 10.0;
    final barWidth = width - rightPadding - leftPadding - 16;
    return GestureDetector(
      onTap: () {
        //todo: focus when tapping on bar
      },
      child: Container(
        width: width - rightPadding - leftPadding,
        height: 94,
        margin: EdgeInsets.fromLTRB(leftPadding, 0, rightPadding, 0),
        child: ClipRRect(
          borderRadius: GlobalStyles.topRadius24,
          child: BackdropFilter(
            filter: GlobalStyles.highBlur,
            child: Container(
              // color: Colors.black,
              decoration: BoxDecoration(
                  color: GlobalColors.primaryGrey.withOpacity(.6),
                  borderRadius: GlobalStyles.topRadius24),
              child: Stack(
                alignment: Alignment.bottomCenter,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //actions - prev, next marker
                  Positioned(
                    bottom: progressBarPos + 16,
                    // left: leftPadding,
                    // right: rightPadding,
                    child: Container(
                      height: 48,
                      width: barWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Tooltip(
                            message: GlobalStrings.jumpToPreviousMarkerTooltip,
                            textStyle: context.bodyText1.copyWith(
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                                color: GlobalColors.primaryRed.withOpacity(.6),
                                borderRadius: GlobalStyles.radiusAll24),
                            verticalOffset: -70,
                            margin: EdgeInsets.only(left: rightPadding),
                            child: IconButton(
                              onPressed: () {
                                onJumpBackward();
                                // onPlay();
                              },
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
                                  child: Icon(FeatherIcons.skipBack,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: width * .74,
                            height: 50,
                            // color: Colors.black,
                            child: Stack(
                                children: markers
                                    .map(
                                      (e) => MarkerPin(
                                        marker: e,
                                        current: e == currentMarker,
                                        totalWidth: barWidth - 130,
                                        onMarkerTap: () {
                                          e.id = markers.indexOf(
                                              e); //set index if non existent
                                          onMarkerTap(e);
                                        },
                                        totalDuration: totalDuration,
                                      ),
                                    )
                                    .toList()),
                          ),
                          SizedBox(width: 12),
                          Tooltip(
                            message: GlobalStrings.jumpToNextMarkerTooltip,
                            textStyle: context.bodyText1.copyWith(
                              color: Colors.white,
                            ),
                            verticalOffset: -70,
                            margin: EdgeInsets.only(right: rightPadding),
                            decoration: BoxDecoration(
                                color: GlobalColors.primaryRed.withOpacity(.6),
                                borderRadius: GlobalStyles.radiusAll24),
                            child: IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                onJumpForward();
                                // onPlay();
                              },
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
                  ),
                  // playback bar with markers on it,
                  Positioned(
                    bottom: progressBarPos,
                    // left: leftPadding,
                    // right: rightPadding,
                    child: Container(
                      width: barWidth,
                      child: ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, VideoPlayerValue value, child) {
                            final elapsed = getDisplayTime(
                                value.position.inMinutes,
                                value.position.inSeconds);

                            final remaining = getDisplayTime(
                                value.duration.inMinutes -
                                    value.position.inMinutes,
                                value.duration.inSeconds -
                                    value.position.inSeconds);

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //elapsed
                                SizedBox(
                                  width: 32,
                                  child: Text(elapsed,
                                      style: context.bodyText1.copyWith(
                                          color: Colors.white, fontSize: 12)),
                                ),

                                //bar
                                SizedBox(
                                  width: barWidth - 64 - 32,
                                  child: ProgressBar(
                                    progress: value.position,
                                    total: value.duration,
                                    timeLabelLocation: TimeLabelLocation.none,
                                    thumbColor: Colors.white,
                                    timeLabelType: TimeLabelType.remainingTime,
                                    baseBarColor:
                                        GlobalColors.primaryRed.withOpacity(.2),
                                    barHeight: 8,
                                    progressBarColor: GlobalColors.primaryRed,
                                    onSeek: (duration) {
                                      onSeek(duration);
                                    },
                                  ),
                                ),

                                SizedBox(
                                  width: 32,
                                  child: Text(remaining,
                                      style: context.bodyText1.copyWith(
                                          color: Colors.white, fontSize: 12)),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  // bottom action and infos
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: inFocus ? 0.0 : 1.0,
                      child: Container(
                        width: barWidth,
                        height: 36,
                        child: Row(
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
                            //playbackbutton
                            ValueListenableBuilder<List<Marker>>(
                                valueListenable: ValueNotifier(markers),
                                builder: (context, value, child) {
                                  if (value.isNotEmpty) {
                                    return TextButton.icon(
                                      icon: Icon(FeatherIcons.playCircle,
                                          size: 20,
                                          color: GlobalColors.primaryRed),
                                      label: Text(GlobalStrings.playback,
                                          style: context.bodyText1.copyWith(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: GlobalColors.primaryRed)),
                                      onPressed: onMarkerPlayback,
                                    );
                                  }
                                  return SizedBox();
                                }),
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
                                              style: context.bodyText1.copyWith(
                                                  color: Colors.white)),
                                          Text("VS",
                                              style: context.bodyText1.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600)),
                                          Text(awayTeam!.name,
                                              style: context.bodyText1.copyWith(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                            const Spacer(),
                            ValueListenableBuilder<List<Marker>>(
                                valueListenable: ValueNotifier(context.select(
                                    (MarkerCubit value) => value.markers)),
                                builder: (context, value, child) {
                                  if (value.isNotEmpty) {
                                    return BlocListener<MarkerCubit,
                                        MarkerState>(
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
                                          context
                                              .read<MarkerCubit>()
                                              .saveData(videoName.parsed);
                                        },
                                      ),
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                            TextButton(
                              child: FaIcon(FeatherIcons.trash2,
                                  size: 20, color: Colors.white),
                              onPressed: () {
                                final playbackBloc =
                                    context.read<PlaybackBloc>();
                                showDialog(
                                    context: context,
                                    useSafeArea: false,
                                    builder: (context) =>
                                        ConfirmationDialog(onConfirm: () {
                                          playbackBloc
                                              .add(DeletePlaybackEvent());
                                          NavUtils.back(context);
                                          NavUtils.toRecording(context);
                                        }));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getDisplayTime(int minutes, int seconds) {
    final minutesStr = (minutes).floor().toString();
    final secondsStr = (seconds).floor().toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
}

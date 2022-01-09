import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/extensions/text_theme_ext.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/dialogs/marker_dialog.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/marker_pin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

typedef DurationCallback = Function(Duration);

class VideoPlayerActions extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final DurationCallback onSeek;
  final VoidCallback onJumpBackward;
  final VoidCallback onJumpForward;
  final MarkerCallback onMarkerTap;
  final List<Marker> markers;
  final Duration totalDuration;
  final VideoPlayerController controller;
  final bool isPlaying;
  final bool inFocus;
  final Team homeTeam;
  final Team awayTeam;
  const VideoPlayerActions(
      {Key? key,
      required this.onPlay,
      required this.onPause,
      required this.onJumpBackward,
      required this.onJumpForward,
      required this.markers,
      this.totalDuration = Duration.zero,
      required this.controller,
      this.isPlaying = false,
      this.inFocus = false,
      required this.homeTeam,
      required this.awayTeam,
      required this.onSeek,
      required this.onMarkerTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //actions - prev, next marker
          Positioned(
            bottom: 60,
            left: 0,
            child: Container(
              height: height * .15,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Tooltip(
                    message: 'Jump to previous marker',
                    child: InkWell(
                      onTap: () {
                        onJumpBackward();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: GlobalColors.primaryRed),
                        child: Center(
                          child:
                              Icon(FeatherIcons.skipBack, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.black,
                    width: width * .8,
                    height: 50,
                    child: Stack(
                        children: markers
                            .map(
                              (e) => MarkerPin(
                                marker: e,
                                totalWidth: width * .8,
                                onMarkerTap: () {
                                  onMarkerTap(e);
                                },
                                totalDuration: totalDuration,
                              ),
                            )
                            .toList()),
                  ),
                  Tooltip(
                    message: 'Jump to next marker',
                    child: IconButton(
                      onPressed: () async {
                        onJumpForward();
                      },
                      icon: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
            bottom: 40,
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
                        baseBarColor: GlobalColors.primaryGrey.withOpacity(.3),
                        progressBarColor: GlobalColors.primaryRed,
                        onSeek: (duration) {
                          onSeek(duration);
                        },
                      );
                    }),
              ),
            ),
          ),
          // // bottom action and infos
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
                                    // service.onPause();
                                    // timer.cancel();
                                  }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Container(
                            width: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(homeTeam.name,
                                    style: context.bodyText1
                                        .copyWith(color: Colors.white)),
                                Text("VS",
                                    style: context.bodyText1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                Text(awayTeam.name,
                                    style: context.bodyText1
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    //trash - to delete video
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: FaIcon(FontAwesomeIcons.trashAlt,
                            color: Colors.white),
                        onPressed: () {},
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

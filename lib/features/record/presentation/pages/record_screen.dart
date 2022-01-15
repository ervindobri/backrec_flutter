import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/utils/ui_utils.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/data/models/team.dart';
import 'package:backrec_flutter/features/record/domain/repositories/recording_repository.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/camera_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/record_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/timer_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/add_marker_button.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/record_button.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/recorded_thumbnail.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/team_selector.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/video_selector_thumbnail.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:backrec_flutter/features/record/presentation/widgets/record_time.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Team? homeTeam, awayTeam;
  final ImagePicker _picker = ImagePicker();
  bool alreadyRecorded = false;
  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  bool recording = false;
  late XFile video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: MultiBlocListener(
          listeners: [
            BlocListener<RecordBloc, RecordState>(
              listener: (context, state) {
                UiUtils.showToast(state.toString());
                print(state);
                if (state is RecordingError) {
                  print(state.message);
                  setState(() => recording = false);
                } else if (state is RecordingStarted) {
                  setState(() => recording = true);
                } else if (state is RecordingStopped) {
                  setState(() {
                    alreadyRecorded = true;
                    recording = false;
                    video = state.video;
                  });
                }
              },
            ),
            BlocListener<TimerBloc, TimerState>(
              listener: (context, state) {
                // print(state);
              },
            ),
          ],
          child:
              BlocBuilder<CameraBloc, CameraState>(builder: (context, state) {
            Widget loadedWidget = SizedBox();
            if (state is CameraLoading) {
              loadedWidget = Center(
                child:
                    CircularProgressIndicator(color: GlobalColors.primaryRed),
              );
            } else if (state is CameraInitialized) {
              loadedWidget = _cameraPreviewWidget(state.controller);
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                loadedWidget, //camera
                BlocProvider(
                  create: (context) => context.read<TimerBloc>(),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: ValueNotifier(recording),
                    builder: (context, value, child) {
                      if (value) {
                        return child!;
                      }
                      return SizedBox();
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RecordTime(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TeamSelector(
                      setTeams: (home, away) {
                        setState(() {
                          homeTeam = home;
                          awayTeam = away;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  child: BlocBuilder<RecordBloc, RecordState>(
                      builder: (context, state) {
                    return RecordButton(
                      onRecord: () {
                        if (!recording) {
                          context.read<RecordBloc>().add(StartRecordEvent());
                          context.read<TimerBloc>().add(TimerStarted());
                          UiUtils.vibrate();
                        } else {
                          context.read<RecordBloc>().add(StopRecordEvent());
                          context.read<TimerBloc>().add(TimerReset());
                          UiUtils.vibrate(duration: 200);
                        }
                      },
                      recordingStarted: recording,
                    );
                  }),
                ),
                Positioned(
                    right: 20,
                    bottom: 20,
                    child: Row(
                      children: [
                        ValueListenableBuilder<bool>(
                            valueListenable: ValueNotifier(alreadyRecorded),
                            builder: (context, value, child) {
                              if (value) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (context) => sl<PlaybackBloc>()
                                          ..add(
                                              InitializeThumbnailEvent(video)),
                                      ),
                                      BlocProvider(
                                        create: (context) => sl<RecordBloc>(),
                                      ),
                                    ],
                                    child: RecordedVideoThumbnail(
                                      video: video,
                                      homeTeam: homeTeam,
                                      awayTeam: awayTeam,
                                      onTap: () async {
                                        final recordingStarted =
                                            sl<RecordingRepository>()
                                                .recordingStarted;
                                        if (recordingStarted) {
                                          context
                                              .read<RecordBloc>()
                                              .add(StopRecordEvent());
                                          UiUtils.vibrate();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }
                              return SizedBox();
                            }),
                        VideoSelectorThumbnail(
                          picker: _picker,
                          awayTeam: awayTeam,
                          homeTeam: homeTeam,
                          onTap: () async {
                            /// If recording started, stop recording and open video from gallery
                            // if (controller.recordingStarted.value) {
                            //   await controller.recordVideo();
                            UiUtils.vibrate();

                            // }
                          },
                        ),
                      ],
                    )),
                ValueListenableBuilder<bool>(
                    valueListenable: ValueNotifier(recording),
                    builder: (context, value, child) {
                      if (value) {
                        return child!;
                      }
                      return SizedBox();
                    },
                    child: Positioned(
                      left: 20,
                      bottom: 20,
                      child: NewMarkerButton(
                        endPosition: getCurrentTimerPosition(context),
                        homeTeam: homeTeam,
                        awayTeam: awayTeam,
                        onTap: () {},
                        onCancel: () {},
                        onMarkerConfigured: (marker) {
                          context.read<MarkerCubit>().addMarker(marker);
                          UiUtils.showToast("Marker created successfully");
                        },
                      ),
                    )),
              ],
            );
          }),
        ));
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget(CameraController controller) {
    return Listener(
      onPointerDown: (_) => _pointers++,
      onPointerUp: (_) => _pointers--,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(
          controller,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                // onScaleStart: _handleScaleStart,
                // onScaleUpdate: _handleScaleUpdate,
                onTapDown: (details) {
                  // context.read<CameraBloc>().add(CameraFocusEvent(details, constraints));
                },
              );
            },
          ),
        ),
      ),
    );
  }

  getCurrentTimerPosition(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutes = ((duration / 600) % 60).floor();
    final seconds = (duration / 10 % 60).floor();
    final milliSeconds = ((duration * 10) % 99);
    // print("Minutes:$minutes:$seconds $milliSeconds");
    return Duration(
        minutes: minutes, seconds: seconds, milliseconds: milliSeconds);
  }
}

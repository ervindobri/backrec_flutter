import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:backrec_flutter/core/utils/ui_utils.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/data/datasources/recording_local_datasource.dart';
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
import 'package:backrec_flutter/models/marker.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/record_time.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late Team homeTeam, awayTeam;
  final ImagePicker _picker = ImagePicker();
  bool alreadyRecorded = false;
  List<Marker> markers = [];
  late CameraController controller;
  @override
  void initState() {
    super.initState();
    homeTeam = new Team(founded: 0000, name: '');
    awayTeam = new Team(founded: 0000, name: '');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: BlocListener<RecordBloc, RecordState>(
          listener: (context, state) {
            UiUtils.showToast(state.toString());
            print(state);
            if (state is RecordingError) {
              print(state.message);
            } else if (state is RecordingStopped) {
              setState(() {
                alreadyRecorded = true;
              });
            }
          },
          child:
              BlocConsumer<CameraBloc, CameraState>(listener: (context, state) {
            if (state is CameraInitialized) {
              controller = state.controller;
            }
          }, builder: (context, state) {
            Widget loadedWidget = SizedBox();
            if (state is CameraInitialized) {
              loadedWidget = _cameraPreviewWidget(state.controller);
            } else if (state is CameraLoading) {
              loadedWidget = Center(
                child:
                    CircularProgressIndicator(color: GlobalColors.primaryRed),
              );
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                loadedWidget,
                // _cameraTogglesRowWidget(),
                // if (state is CameraInitialized)
                //   ValueListenableBuilder<CameraValue>(
                //       valueListenable: controller,
                //       builder: (context, CameraValue value, child) {
                //         if (value.isRecordingVideo) {
                //           return
                Align(
                  alignment: Alignment.topLeft,
                  child: BlocProvider(
                    create: (context) =>
                        context.read<TimerBloc>()..add(TimerStarted()),
                    child: RecordTime(),
                  ),
                )
                //     ;
                //   } else {
                //     return SizedBox();
                //   }
                // }),
                ,
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TeamSelector(
                      initialHome: homeTeam,
                      initialAway: awayTeam,
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
                    var value = false;
                    if (state is RecordingStarted) {
                      value = true;
                    } else if (state is RecordingStopped) {
                      value = false;
                    }
                    return RecordButton(
                      onRecord: () {
                        if (!value) {
                          context.read<RecordBloc>().add(StartRecordEvent());
                          UiUtils.vibrate();
                        } else {
                          context.read<RecordBloc>().add(StopRecordEvent());
                          context.read<TimerBloc>().add(TimerReset());
                          UiUtils.vibrate(duration: 200);
                        }
                      },
                      recordingStarted: value,
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
                                final video =
                                    sl<RecordingLocalDataSource>().video;
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
                                        create: (context) =>
                                            context.read<RecordBloc>(),
                                      ),
                                    ],
                                    child: RecordedVideoThumbnail(
                                      video: video,
                                      homeTeam: homeTeam,
                                      awayTeam: awayTeam,
                                      markers: markers,
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
                // if (controller.recordingStarted.value)
                // Positioned(
                //     left: 20,
                //     bottom: 20,
                //     child: Row(
                //       children: [
                //         NewMarkerButton(
                //           endPosition: controller,
                //           homeTeam: homeTeam,
                //           awayTeam: awayTeam,
                //           onTap: () {},
                //           onCancel: () {},
                //           onMarkerConfigured: (marker) {
                //             markers.add(marker);
                //             UiUtils.showToast("Marker created successfully");
                //           },
                //         ),
                //       ],
                //     ))
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
      child: FutureBuilder(
          future: controller.initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(
                    controller,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        // onScaleStart: _handleScaleStart,
                        // onScaleUpdate: _handleScaleUpdate,
                        onTapDown: (details) {
                          // context.read<CameraBloc>().add(CameraFocusEvent(details, constraints));
                        },
                      );
                    }),
                  ));
            } else {
              return Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    color: GlobalColors.primaryRed,
                  ),
                ),
              );
            }
          }),
    );
  }
}

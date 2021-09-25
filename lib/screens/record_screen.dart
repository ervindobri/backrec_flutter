import 'package:backrec_flutter/bloc/playback_bloc.dart';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/controllers/record_controller.dart';
import 'package:backrec_flutter/controllers/toast_controller.dart';
import 'package:backrec_flutter/models/team.dart';
import 'package:backrec_flutter/widgets/buttons/add_marker_button.dart';
import 'package:backrec_flutter/widgets/buttons/record_button.dart';
import 'package:backrec_flutter/widgets/record_time.dart';
import 'package:backrec_flutter/widgets/buttons/recorded_thumbnail.dart';
import 'package:backrec_flutter/widgets/team_selector.dart';
import 'package:backrec_flutter/widgets/buttons/video_selector_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late Team homeTeam, awayTeam;

  T? _ambiguate<T>(T? value) => value;

  RecordController recordController = Get.put(RecordController());
  ToastController toastController = Get.put(ToastController());
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    homeTeam = new Team(founded: 0000, name: '');
    awayTeam = new Team(founded: 0000, name: '');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
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
      body: GetBuilder<ToastController>(
          init: toastController,
          builder: (toastController) {
            return GetBuilder<RecordController>(
                init: recordController,
                builder: (controller) {
                  return Obx(
                    () => Stack(
                      alignment: Alignment.center,
                      children: [
                        _cameraPreviewWidget(controller),
                        // _cameraTogglesRowWidget(),
                        if (controller.recordingStarted.value)
                          Align(
                            alignment: Alignment.topLeft,
                            child: RecordTime(
                                blinkColor: controller.blinkColor.value,
                                timePassed: controller.timePassed.value),
                          ),
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
                          child: RecordButton(
                            onRecord: () {
                              controller.recordVideo();
                              // controller.recordingStarted.value =
                              //     !controller.recordingStarted.value;
                              Vibration.vibrate(duration: 50);
                            },
                            recordingStarted: controller.recordingStarted.value,
                          ),
                        ),
                        Obx(
                          () => Positioned(
                              right: 20,
                              bottom: 20,
                              child: BlocProvider(
                                create: (context) =>
                                    context.read<PlaybackBloc>(),
                                child: Row(
                                  children: [
                                    if (controller.alreadyRecorded.value)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: RecordedVideoThumbnail(
                                          video: controller.videoFile.value,
                                          homeTeam: homeTeam,
                                          awayTeam: awayTeam,
                                          onTap: () async {
                                            if (controller
                                                .recordingStarted.value) {
                                              await controller.recordVideo();
                                              Vibration.vibrate(duration: 50);
                                            }
                                          },
                                        ),
                                      ),
                                    VideoSelectorThumbnail(
                                      picker: _picker,
                                      awayTeam: awayTeam,
                                      homeTeam: homeTeam,
                                      onTap: () async {
                                        /// If recording started, stop recording and open video from gallery
                                        if (controller.recordingStarted.value) {
                                          await controller.recordVideo();
                                          Vibration.vibrate(duration: 50);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        if (controller.recordingStarted.value)
                          Positioned(
                              left: 20,
                              bottom: 20,
                              child: Row(
                                children: [
                                  NewMarkerButton(
                                    endPosition: controller.elapsed,
                                    homeTeam: homeTeam,
                                    awayTeam: awayTeam,
                                    onTap: () {},
                                    onCancel: () {},
                                    onMarkerConfigured: (marker) {
                                      recordController.saveMarker(marker);
                                      toastController.showToast(
                                          "Marker created successfully",
                                          Icon(Icons.check,
                                              color: Colors.white));
                                    },
                                  ),
                                ],
                              ))
                      ],
                    ),
                  );
                });
          }),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget(RecordController controller) {
    return Listener(
      onPointerDown: (_) => _pointers++,
      onPointerUp: (_) => _pointers--,
      child: FutureBuilder(
          future: controller.controllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                  aspectRatio: controller.controller!.value.aspectRatio,
                  child: CameraPreview(
                    controller.controller!,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        // onScaleStart: _handleScaleStart,
                        // onScaleUpdate: _handleScaleUpdate,
                        onTapDown: (details) =>
                            controller.onViewFinderTap(details, constraints),
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

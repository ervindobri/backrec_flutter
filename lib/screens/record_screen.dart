import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/controllers/record_controller.dart';
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
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    homeTeam = new Team(founded: 0000, name: '');
    awayTeam = new Team(founded: 0000, name: '');
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    super.dispose();
  }

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RecordController>(
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
                        onRecord: controller.recordVideo,
                        recordingStarted: controller.recordingStarted.value),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: controller.alreadyRecorded.value
                        ? RecordedVideoThumbnail(
                            video: controller.videoFile.value,
                            homeTeam: homeTeam,
                            awayTeam: awayTeam,
                          )
                        : VideoSelectorThumbnail(
                            picker: _picker,
                            awayTeam: awayTeam,
                            homeTeam: homeTeam,
                          ),
                  ),
                  // if (controller.recordingStarted.value)
                  Positioned(
                      left: 20,
                      bottom: 20,
                      child: Row(
                        children: [
                          NewMarkerButton(
                            endPosition: controller.elapsed,
                            homeTeam: homeTeam,
                            awayTeam: awayTeam,
                            onMarkerConfigured: (marker) {
                              recordController.saveMarker(marker);
                              //TODO: feedback with snackbar/toast
                            },
                          ),
                        ],
                      ))
                ],
              ),
            );
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
              return Transform.scale(
                scale: 1,
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
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: GlobalColors.primaryGrey,
                  color: GlobalColors.primaryRed,
                ),
              );
            }
          }),
    );
  }
}

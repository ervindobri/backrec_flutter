import 'dart:typed_data';

import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/controllers/record_controller.dart';
import 'package:backrec_flutter/main.dart';
import 'package:backrec_flutter/screens/playback_screen.dart';
import 'package:backrec_flutter/widgets/record_button.dart';
import 'package:backrec_flutter/widgets/record_time.dart';
import 'package:backrec_flutter/widgets/recorded_thumbnail.dart';
import 'package:backrec_flutter/widgets/team_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    default:
      throw ArgumentError('Unknown lens direction');
  }
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool enableAudio = true;

  T? _ambiguate<T>(T? value) => value;
  RecordController recordController = Get.put(RecordController());
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
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
                      child: TeamSelector(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RecordButton(
                          onRecord: controller.recordVideo,
                          recordingStarted: controller.recordingStarted.value),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20),
                      child: controller.alreadyRecorded.value
                          ? RecordedVideoThumbnail(
                              video: controller.videoFile.value,
                            )
                          : InkWell(
                              onTap: () async {
                                final XFile? video = await _picker.pickVideo(
                                    source: ImageSource.gallery);
                                print(video!.name);
                                if (video.name != "") {
                                  Get.to(() => PlaybackScreen(video: video));
                                }
                              },
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: GlobalColors.primaryGrey
                                          .withOpacity(.4)),
                                  child: Center(
                                    child: Icon(FeatherIcons.file,
                                        color: Colors.white),
                                  )),
                            ),
                    ),
                  )
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
                scale: 1.3,
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
                  color: GlobalColors.primaryRed,
                ),
              );
            }
          }),
    );
  }
}

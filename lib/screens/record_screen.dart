import 'dart:typed_data';

import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/main.dart';
import 'package:backrec_flutter/widgets/record_button.dart';
import 'package:backrec_flutter/widgets/record_time.dart';
import 'package:backrec_flutter/widgets/recorded_thumbnail.dart';
import 'package:backrec_flutter/widgets/team_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:async';
import 'package:camera/camera.dart';
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
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;

  late CameraDescription backCamera;

  bool _recordingStarted = false;
  bool _recordingStopped = false;

  late String startRecordTime;
  late String timePassed;
  late Timer recTimer;

  late Uint8List? thumbnail;

  var blinkColor;

  var _initializeControllerFuture;
  var _alreadyRecorded = false;

  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    startRecordTime = timestamp();
    timePassed = calculateTimePassed();
    blinkColor = GlobalColors.primaryRed;
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    backCamera = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back);

    print("Back camera selected! $backCamera");
    onNewCameraSelected(backCamera);

    recTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_recordingStopped) {
        print("Cancelled.");
        timer.cancel();
        return;
      }
      setState(() {
        timePassed = calculateTimePassed();
        blinkColor = GlobalColors.primaryRed == blinkColor
            ? Colors.transparent
            : GlobalColors.primaryRed;
      });
    });
    _initializeControllerFuture = controller!.initialize();
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    recTimer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _cameraPreviewWidget(),
          // _cameraTogglesRowWidget(),
          if (_recordingStarted)
            Align(
              alignment: Alignment.topLeft,
              child: RecordTime(blinkColor: blinkColor, timePassed: timePassed),
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
                  onRecord: recordVideo, recordingStarted: _recordingStarted),
            ),
          ),
          if (_alreadyRecorded)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: RecordedVideoThumbnail(
                  video: videoFile,
                  // controller: videoController!,
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> recordVideo() async {
    if (_recordingStarted) {
      onStopButtonPressed();
      setState(() {
        _recordingStarted = false;
        _recordingStopped = true;
      });
    } else {
      onVideoRecordButtonPressed();
      setState(() {
        _recordingStarted = true;
        _recordingStopped = false;
        timePassed = "0:00";
        startRecordTime = timestamp();
      });
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null) {
      return Container(
        child: CircularProgressIndicator(
          color: GlobalColors.primaryRed,
        ),
      );
    }
    return Listener(
      onPointerDown: (_) => _pointers++,
      onPointerUp: (_) => _pointers--,
      child: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Transform.scale(
                scale: 1.3,
                child: CameraPreview(
                  controller!,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      // onScaleStart: _handleScaleStart,
                      // onScaleUpdate: _handleScaleUpdate,
                      onTapDown: (details) =>
                          onViewFinderTap(details, constraints),
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

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  String calculateTimePassed() {
    final date1 =
        DateTime.fromMillisecondsSinceEpoch(int.parse(startRecordTime));
    final date2 = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp()));
    final milliseconds = date2.difference(date1).inMilliseconds;
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr".toString();
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Function for setting focus point
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high, //hd resolution: 1280x720
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );
    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) async {
      if (mounted) setState(() {});
      if (file != null) {
        //TODO: new snackbar/notifier
        var saved = await GallerySaver.saveVideo(file.path);
        print("Video saved to library: $saved, ${file.name}");
        setState(() {
          videoFile = file;
          _alreadyRecorded = true;
        });
      }
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

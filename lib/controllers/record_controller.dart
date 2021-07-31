import 'dart:async';
import 'dart:ui';

import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/screens/record_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class RecordController extends GetxController with WidgetsBindingObserver {
  var _initialized;
  Rx<XFile> videoFile = XFile("").obs;

  CameraController? controller;
  VideoPlayerController? videoController;
  bool enableAudio = true;

  late CameraDescription backCamera;

  late List<CameraDescription> cameras;
  RxBool _recordingStarted = false.obs;
  RxBool get recordingStarted => _recordingStarted;
  RxBool _recordingStopped = false.obs;
  RxBool get recordingStopped => _recordingStopped;

  late String startRecordTime;
  RxString timePassed = "".obs;
  late Timer recTimer;

  Rx<Color> blinkColor = Color(0xfffff).obs;
  RxBool _alreadyRecorded = false.obs;
  RxBool get alreadyRecorded => _alreadyRecorded;

  T? _ambiguate<T>(T? value) => value;
  @override
  // TODO: implement initialized
  bool get initialized => _initialized;
  late Future<void> _initializeControllerFuture = Future(() {});
  Future<void> get controllerFuture => _initializeControllerFuture;
  @override
  void onInit() {
    super.onInit();
    getCameras();
    // startRecordTime = timestamp();
    // timePassed.value = calculateTimePassed();
    _initialized = true;
  }

  void getCameras() async {
    // Fetch the available cameras before initializing the app.
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
      backCamera = cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      // print(backCamera);
      onNewCameraSelected(backCamera);
      _initializeControllerFuture = controller!.initialize();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
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

  Future<void> recordVideo() async {
    if (_recordingStarted.value) {
      onStopButtonPressed();
      _recordingStarted.value = false;
      _recordingStopped.value = true;
    } else {
      onVideoRecordButtonPressed();
      _recordingStarted.value = true;
      _recordingStopped.value = false;
      timePassed.value = "0:00";
      startRecordTime = timestamp();
    }
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
    controller!.lockCaptureOrientation(DeviceOrientation.landscapeLeft);

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      // if (mounted) setState(() {});
      notifyChildrens();
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
    notifyChildrens();
    // if (mounted) {
    // setState(() {});
    // }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {
      // if (mounted)
      // setState(() {
      recTimer = startTimer();
      _alreadyRecorded.value = false;
      // });
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((file) async {
      // if (mounted) setState(() {});
      if (file != null) {
        //TODO: new snackbar/notifier
        var saved = await GallerySaver.saveVideo(file.path);
        print("stop record - ${file.name}");
        // setState(() {
        videoFile.value = file;
        _alreadyRecorded.value = true;
        // });
      }
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

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Timer startTimer() {
    return Timer.periodic(Duration(seconds: 1), (timer) {
      if (_recordingStopped.value) {
        // print("Cancelled.");
        timer.cancel();
        return;
      }
      timePassed.value = calculateTimePassed();
      blinkColor.value = GlobalColors.primaryRed == blinkColor.value
          ? Colors.transparent
          : GlobalColors.primaryRed;
    });
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    Get.showSnackbar(GetBar(titleText: Text(message)));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
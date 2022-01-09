import 'dart:io';
import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';

abstract class RecordingLocalDataSource {
  List<Marker>? markers;

  bool alreadyRecorded = false;

  late XFile video;
  Future<String> setMarkers(List<Marker> markers);
  Future<String> startRecording();
  Future<String> stopRecording();

  Future<CameraController> initializeCamera();
  Future<String> focusCamera();
}

class RecordingLocalDataSourceImpl implements RecordingLocalDataSource {
  @override
  List<Marker>? markers;

  @override
  bool alreadyRecorded = false;

  @override
  late XFile video;
  CameraController? controller;
  XFile videoFile = XFile("");

  late List<CameraDescription> cameras;
  late CameraDescription backCamera;

  bool _recordingStarted = false;
  bool _recordingStopped = false;

  @override
  Future<String> setMarkers(List<Marker> markers) {
    this.markers = markers;
    return Future.value("Markers set successfully!");
  }

  void deleteVideo() async {
    var temp = File(videoFile.path);
    await temp.delete();
  }

  @override
  Future<String> startRecording() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      throw RecordingException("Select a camera first!");
    } else {
      if (cameraController.value.isRecordingVideo) {
        //do nothing
      } else {
        await cameraController.startVideoRecording();
        _recordingStarted = true;
        _recordingStopped = false;
        return Future.value("Camera started!");
      }
    }
    // A recording is already started, do nothing.
    throw RecordingException("Recording already started.");
  }

  @override
  Future<String> stopRecording() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      throw RecordingException("Select a camera first!");
    }
    try {
      // Get file
      videoFile = await cameraController.stopVideoRecording();
      // Save to gallery (because can't load back from app path)
      await GallerySaver.saveVideo(videoFile.path);
      video = videoFile;
    } catch (e) {
      throw RecordingException(e.toString());
    }
    _recordingStarted = false;
    _recordingStopped = true;
    alreadyRecorded = true;
    return Future.value("Video saved to Gallery!");
  }

  @override
  Future<String> focusCamera(
      // TapDownDetails details, BoxConstraints constraints
      ) {
    // if (controller == null) {
    //   return Future.value("NO_CAMERA");
    // }
    // final CameraController cameraController = controller!;

    // final offset = Offset(
    //   details.localPosition.dx / constraints.maxWidth,
    //   details.localPosition.dy / constraints.maxHeight,
    // );
    // cameraController.setExposurePoint(offset);
    // cameraController.setFocusPoint(offset);
    //   return Future.value("NO_CAMERA");
    throw UnimplementedError("");
  }

  Future<void> getCameras() async {
    // Fetch the available cameras before initializing the app.
    try {
      cameras = await availableCameras();
      backCamera = cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      onNewCameraSelected(backCamera);
    } on CameraException catch (e) {
      throw RecordingException(e.description ?? e.toString());
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high, //hd resolution: 1280x720
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );
    controller = cameraController;
    // controller!.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    // controller!.unlockCaptureOrientation();

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      // if (mounted) setState(() {});
      if (cameraController.value.hasError) {
        throw CameraException(
            'ERR', '${cameraController.value.errorDescription}');
      }
    });
    await cameraController.initialize();
  }

  @override
  Future<CameraController> initializeCamera() async {
    try {
      print("Initializing cameras...");
      //list all cameras and select back one;
      await getCameras();
      return controller!;
    } catch (e) {
      throw CameraException("ERR", e.toString());
    }
  }
}

import 'dart:io';
import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';

abstract class RecordingLocalDataSource {
  List<Marker>? markers;

  bool alreadyRecorded = false;

  late XFile video;
  Future<String> setMarkers(List<Marker> markers);
  Future<String> startRecording();
  Future<XFile> stopRecording();

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
    print(cameraController.hashCode);

    if (cameraController == null || !cameraController.value.isInitialized) {
      print('Error: select a camera first.');
      throw RecordingException("Select a camera first!");
    } else {
      if (cameraController.value.isRecordingVideo) {
        //do nothing
        throw RecordingException("Recording already started.");
      } else {
        cameraController.startVideoRecording().then((value) {
          print("started");
        });
        return Future.value("Camera started!");
      }
    }
  }

  /// Stop recording with the camera controller & save video file to gallery
  @override
  Future<XFile> stopRecording() async {
    final CameraController? cameraController = controller;
    print(cameraController.hashCode);
    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      throw RecordingException("Select a camera first!");
    }
    try {
      // Get file
      videoFile = await cameraController.stopVideoRecording();
      video = videoFile;
      // Save to gallery (because can't load back from app path)
      await GallerySaver.saveVideo(videoFile.path);
      return video;
    } catch (e) {
      throw RecordingException(e.toString());
    }
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

  /// Fetch the available cameras before initializing the app.
  Future<void> getCameras() async {
    try {
      cameras = await availableCameras();
      backCamera = cameras.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      await onNewCameraSelected(backCamera);
    } on CameraException catch (e) {
      throw RecordingException(e.description ?? e.toString());
    }
  }

  /// Selecting a new camera re-initializes the controller
  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
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
    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (cameraController.value.hasError) {
        throw CameraException(
            'ERR', '${cameraController.value.errorDescription}');
      }
    });
    await cameraController.initialize();
  }

  /// This method will be used to initialize the controller
  @override
  Future<CameraController> initializeCamera() async {
    try {
      print("Initializing cameras...");
      //list all cameras and select back one;
      await getCameras();
      return controller!;
    } catch (e) {
      initializeCamera();
      throw CameraException("ERR", e.toString());
    }
  }
}

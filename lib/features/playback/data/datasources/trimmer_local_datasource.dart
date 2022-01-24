import 'dart:io';
import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/core/extensions/string_ext.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:video_trimmer/video_trimmer.dart';

abstract class TrimmerLocalDataSource {
  Future<String> trimVideo(String videoPath, List<Marker> markers);

  Future<void> createClip(Marker marker);
  Future<void> loadVideo(String videoPath);
}

class TrimmerLocalDataSourceImpl implements TrimmerLocalDataSource {
  late Trimmer _trimmer;
  late String path;

  @override
  Future<String> trimVideo(String videoPath, List<Marker> markers) async {
    try {
      final video = File(videoPath);
      final trimmer = Trimmer();
      await trimmer.loadVideo(videoFile: video);
      print(
          "Saving clips to: ${StorageDir.applicationDocumentsDirectory} ${videoPath.parsedPath}");
      markers.forEach((marker) {
        final clipPath = trimmer.saveTrimmedVideo(
          startValue: marker.startPosition.inMilliseconds.floorToDouble(),
          endValue: marker.endPosition.inMilliseconds.floorToDouble(),
          storageDir: StorageDir.applicationDocumentsDirectory,
          videoFolderName: videoPath.parsedPath,
          videoFileName: marker.id.toString(),
        );
        print(clipPath);
      });
      return "Video trimmed successfully!";
    } on Exception catch (e) {
      throw TrimmerException(e.toString());
    }
  }

  @override
  Future<void> createClip(Marker marker) async {
    try {
      final clipPath = await _trimmer.saveTrimmedVideo(
        startValue: marker.startPosition.inMilliseconds.floorToDouble(),
        endValue: marker.endPosition.inMilliseconds.floorToDouble(),
        storageDir: StorageDir.applicationDocumentsDirectory,
        videoFolderName: path.parsedPath,
        videoFileName: marker.id.toString(),
      );
      print(clipPath);
    } catch (e) {
      print(e);
      throw TrimmerException(e.toString());
    }
  }

  @override
  Future<void> loadVideo(String videoPath) async {
    try {
      final video = File(videoPath);
      path = videoPath;
      _trimmer = Trimmer();
      await _trimmer.loadVideo(videoFile: video);
    } catch (e) {
      throw TrimmerException(e.toString());
    }
  }
}

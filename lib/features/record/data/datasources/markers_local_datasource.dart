import 'dart:convert';
import 'dart:io';

import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:path_provider/path_provider.dart';

abstract class MarkersLocalDataSource {
  List<Marker> markers = [];

  Future<void> addMarker(Marker marker);

  Future<void> removeMarker(Marker marker);

  Future<void> setMarkers(List<Marker> markers);
  Future<void> clearMarkers();

  ///Save data locally
  Future<void> saveMarkers(String videoName);
  Future<void> loadMarkers(String videoName);
  Future<void> updateMarker(Marker marker);
}

class MarkersLocalDataSourceImpl implements MarkersLocalDataSource {
  @override
  Future<void> addMarker(Marker marker) async {
    this.markers.add(marker);
  }

  @override
  Future<void> removeMarker(Marker marker) async {
    this.markers.remove(marker);
  }

  @override
  Future<void> saveMarkers(String videoName) async {
    try {
      if (this.markers.isNotEmpty) {
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        final videoPath = "$path/$videoName";
        final videoDirectory = Directory(videoPath);
        if (await videoDirectory.exists()) {
          final markerFile = File('$videoPath/markers.json');
          final markerIds = this.markers.map((e) => e.id).toSet();
          this.markers.retainWhere((element) => markerIds.remove(element.id));
          final content = json.encode(this.markers);
          print(content);
          markerFile.writeAsString(content);
        } else {
          final newDir = await Directory(videoPath).create(recursive: true);
          final markerFile = File('${newDir.path}/markers.json');
          final markerIds = this.markers.map((e) => e.id).toSet();
          this.markers.retainWhere((element) => markerIds.remove(element.id));
          final content = json.encode(this.markers);
          print(content);
          markerFile.writeAsString(content);
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<void> setMarkers(List<Marker> markers) async {
    this.markers = markers;
  }

  @override
  List<Marker> markers = [];

  @override
  Future<void> clearMarkers() async {
    this.markers.clear();
  }

  @override
  Future<void> loadMarkers(String videoName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final videoPath = "$path/$videoName";
    final videoDirectory = Directory(videoPath);
    if (await videoDirectory.exists()) {
      //load back markers
      final fileName = '$videoPath/markers.json';
      final markerFile = File(fileName);
      if (await markerFile.exists()) {
        final data = json.decode(await markerFile.readAsString());
        print("data: $data");
        data.asMap().forEach((index, piece) {
          final marker = Marker.fromJson(piece, index);
          markers.add(marker);
        });
      }
      List<Marker> removeables = [];
      for (var item1 in markers) {
        for (var item2 in markers) {
          if (item1 != item2) {
            if (item1.startPosition.inMilliseconds ==
                item2.startPosition.inMilliseconds) {
              removeables.add(item1);
              break;
            }
          }
        }
      }
      for (var item in removeables) {
        print("$item removed");
        markers.remove(item);
      }
    }
  }

  @override
  Future<void> updateMarker(Marker marker) async {
    this.markers.removeWhere((element) =>
        element.id == marker.id || element.endPosition == marker.endPosition);
    await addMarker(marker);
  }
}

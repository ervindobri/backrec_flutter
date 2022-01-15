import 'dart:convert';
import 'dart:io';

import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:path_provider/path_provider.dart';

abstract class MarkersLocalDataSource {
  List<Marker> markers = [];

  Future<void> addMarker(Marker marker);

  Future<void> removeMarker(Marker marker);

  Future<void> setMarkers(List<Marker> markers);

  ///Save data locally
  Future<void> saveMarkers(String videoName);
}

class MarkersLocalDataSourceImpl implements MarkersLocalDataSource {
  @override
  Future<void> addMarker(Marker marker) {
    // TODO: implement addMarker
    throw UnimplementedError();
  }

  @override
  Future<void> removeMarker(Marker marker) {
    // TODO: implement removeMarker
    throw UnimplementedError();
  }

  @override
  Future<void> saveMarkers(String videoName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final markerFile = File('$path/$videoName.json');
    final content = json.encode(this.markers);
    markerFile.writeAsString(content);
  }

  @override
  Future<void> setMarkers(List<Marker> markers) {
    // TODO: implement setMarkers
    throw UnimplementedError();
  }

  @override
  List<Marker> markers = [];
}

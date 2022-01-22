import 'package:backrec_flutter/features/record/data/models/marker.dart';

abstract class MarkerRepository {
  List<Marker> markers = [];
  Future<void> setMarkers(List<Marker> markers);
  List<Marker> getMarkers();
  Future<void> clearMarkers();
  Future<void> addMarker(Marker markers);
  Future<void> removeMarker(Marker markers);

  Future<void> saveMarkers(String videoName);
  Future<void> loadMarkers(String name);
  Future<void> updateMarker(Marker marker);
}

import 'package:backrec_flutter/features/record/data/datasources/markers_local_datasource.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/domain/repositories/marker_repository.dart';

class MarkerRepositoryImpl extends MarkerRepository {
  final MarkersLocalDataSource localDataSource;
  MarkerRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addMarker(Marker marker) async {
    this.markers.add(marker);
  }

  @override
  Future<void> removeMarker(Marker marker) async {
    this.markers.remove(marker);
  }

  @override
  Future<void> setMarkers(List<Marker> markers) async {
    this.markers = [...markers];
  }

  @override
  Future<void> saveMarkers(String videoName) async {
    await localDataSource.saveMarkers(videoName);
  }
}

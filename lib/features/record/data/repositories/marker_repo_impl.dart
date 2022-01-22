import 'package:backrec_flutter/features/record/data/datasources/markers_local_datasource.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/domain/repositories/marker_repository.dart';

class MarkerRepositoryImpl extends MarkerRepository {
  final MarkersLocalDataSource localDataSource;
  MarkerRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addMarker(Marker marker) async {
    await localDataSource.addMarker(marker);
  }

  @override
  Future<void> removeMarker(Marker marker) async {
    await localDataSource.removeMarker(marker);
  }

  @override
  Future<void> setMarkers(List<Marker> markers) async {
    await localDataSource.setMarkers(markers);
  }

  @override
  Future<void> saveMarkers(String videoName) async {
    await localDataSource.saveMarkers(videoName);
  }

  @override
  Future<void> clearMarkers() async {
    await localDataSource.clearMarkers();
  }

  @override
  List<Marker> getMarkers() {
    return localDataSource.markers;
  }

  @override
  Future<void> loadMarkers(String name) async {
    await localDataSource.loadMarkers(name);
  }

  @override
  Future<void> updateMarker(Marker marker) async {
    await localDataSource.updateMarker(marker);
    
  }
}

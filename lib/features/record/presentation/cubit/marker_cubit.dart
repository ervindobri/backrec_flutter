import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/domain/repositories/marker_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:backrec_flutter/core/extensions/list_ext.dart';
part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  final MarkerRepository repository;
  MarkerCubit({required this.repository}) : super(MarkerInitial());

  List<Marker> get markers {
    return repository.getMarkers();
  }

  Future<void> addMarker(Marker marker) async {
    emit(MarkerLoading());
    await repository.addMarker(marker);
    emit(MarkerAdded());
  }

  Future<void> removeMarker(Marker marker) async {
    emit(MarkerLoading());
    await repository.removeMarker(marker);
    emit(MarkerRemoved());
  }

  Future<void> setMarkers(List<Marker> markers) async {
    emit(MarkerLoading());
    await repository.setMarkers(markers);
    emit(MarkerLoaded());
  }

  Future<void> saveData(String videoName) async {
    emit(MarkerLoading());
    await repository.saveMarkers(videoName);
    emit(MarkerSaved());
  }

  Future<void> clearMarkers() async {
    print("Clearing markers...");
    emit(MarkerLoading());
    await repository.clearMarkers();
    emit(MarkerCleared());
  }

  Future<void> loadMarkers(String name) async {
    print("Loading back video markers...");
    emit(MarkerLoading());
    await clearMarkers();
    await repository.loadMarkers(name);
    emit(MarkerLoaded());
  }

  Marker? findPreviousMarker(Duration elapsed) {
    print("Elapsed: ${elapsed.inMilliseconds}");
    print(markers);
    if (markers.length > 0 && elapsed.inMilliseconds > 10) {
      Marker closest = markers
          .where((element) => element.startPosition.compareTo(elapsed) < 0)
          .reduce((a, b) {
        // print(
        // "$a $b ${(a.endPosition.inMilliseconds - elapsed.inMilliseconds).abs()} < ${(b.endPosition.inMilliseconds - elapsed.inMilliseconds).abs()}");
        return (a.startPosition.inMilliseconds - elapsed.inMilliseconds).abs() <
                (b.startPosition.inMilliseconds - elapsed.inMilliseconds).abs()
            ? a
            : b;
      });
      print("Closest: ${closest.startPosition}");
      return closest;
    }
    return null;
  }

  Marker? findNextMarker(Duration elapsed) {
    if (markers.length > 0) {
      Marker? firstMarker = markers
          .where((element) => element.startPosition.compareTo(elapsed) >= 0)
          .toList()
          .firstWhereOrNull((element) => element.startPosition > elapsed);
      return firstMarker;
    }
    return null;
  }

  Marker? markerVisible(Duration elapsed) {
    if (markers.isNotEmpty) {
      final Marker? nextMarker = markers.firstWhereOrNull(
        (element) =>
            element.startPosition.compareTo(elapsed) < 0 &&
            element.endPosition.compareTo(elapsed) >= 0,
      );
      if (nextMarker != null) {
        if (nextMarker.endPosition.compareTo(elapsed) >= 0) {
          return nextMarker;
        }
        return null;
      }
    }
    return null;
  }

  Future<void> updateMarker(Marker marker) async {
    emit(MarkerLoading());
    await repository.updateMarker(marker);
    emit(MarkerLoaded());
  }

  void deleteMarker(Marker marker) {}

  bool isInterfereing(Duration elapsed) {
    print(elapsed);
    final clipDuration = Duration(seconds: 12);
    for (var item in markers) {
      print(item.startPosition.compareTo(elapsed));
      print(elapsed.compareTo(item.endPosition));
      final endOffset = item.endPosition + clipDuration;
      // If elapsed is between starPos and endPos
      if (item.startPosition.compareTo(elapsed) <= 0 &&
          elapsed.compareTo(item.endPosition) < 1) {
        return true;
      } else if (elapsed.compareTo(item.endPosition) >= 0 &&
          elapsed.compareTo(endOffset) <= 0) {
        return true;
      }
      // Or the new marker will be too close to the endPos
    }
    return false;
  }

  noMoreMarkers(Duration elapsed) {
    final lastMarker = markers
        .reduce((a, b) => a.endPosition.compareTo(b.endPosition) > 0 ? a : b);
    if (elapsed.compareTo(lastMarker.endPosition) > 0) {
      return true;
    }
    return false;
  }
}

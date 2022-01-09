import 'package:backrec_flutter/features/playback/domain/repositories/playback_repository.dart';
import 'package:backrec_flutter/models/marker.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  final PlaybackRepository repository;
  MarkerCubit({required this.repository}) : super(MarkerInitial());

  addMarker(Marker marker) {
    emit(MarkerLoading());
    repository.markers.add(marker);
    emit(MarkerAdded());

  }

  setMarkers(List<Marker> markers) {
    emit(MarkerLoading());
    repository.markers = [...markers];
    emit(MarkerAdded());

  }

  void saveMarker(Marker marker) {}
}

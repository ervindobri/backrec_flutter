import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:backrec_flutter/features/record/domain/repositories/marker_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  final MarkerRepository repository;
  MarkerCubit({required this.repository}) : super(MarkerInitial());

  List<Marker> markers(){
    return repository.markers;
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
}

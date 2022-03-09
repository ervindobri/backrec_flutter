import 'package:backrec_flutter/core/error/exceptions.dart';
import 'package:backrec_flutter/features/playback/domain/repositories/trimmer_repository.dart';
import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'trimmer_state.dart';

class TrimmerCubit extends Cubit<TrimmerState> {
  final TrimmerRepository repository;
  TrimmerCubit({required this.repository}) : super(TrimmerInitial());

  trimVideo({required String video, required List<Marker> markers}) async {
    try {
      emit(TrimmerLoading());
      await Future.delayed(Duration(milliseconds: 1200));
      await repository.loadVideo(video);
      emit(TrimmerVideoLoaded());
      markers.forEach((marker) async {
        emit(TrimmerMarkersLoaded());
        await repository.createClip(marker);
        await Future.delayed(Duration(milliseconds: 900));
        emit(TrimmerTrimming());
      });
      await Future.delayed(Duration(milliseconds: 1800));
      emit(TrimmerFinished());
    } on TrimmerException catch (e) {
      TrimmerError(e.message);
    }
  }
  
}

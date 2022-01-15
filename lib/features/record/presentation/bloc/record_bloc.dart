import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/record/domain/usecases/start_recording.dart';
import 'package:backrec_flutter/features/record/domain/usecases/stop_recording.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  final StartRecording startRecording;
  final StopRecording stopRecording;
  RecordBloc({required this.startRecording, required this.stopRecording})
      : super(RecordingInitial()) {
    on<RecordEvent>((event, emit) async {
      print(event);
      if (event is StartRecordEvent) {
        emit(RecordingLoading());
        final result = await startRecording(null);
        emit(result.fold(
          (failure) =>
              RecordingError(_mapFailureToMessage(failure)), //todo: map errors
          (series) => RecordingStarted(series),
        ));
      } else if (event is StopRecordEvent) {
        emit(RecordingLoading());
        final result = await stopRecording(null);
        emit(result.fold(
          (failure) =>
              RecordingError(_mapFailureToMessage(failure)), //todo: map errors
          (video) => RecordingStopped(video),
        ));
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case RecordingFailure:
        return (failure as RecordingFailure).message;
      default:
        return failure.toString();
    }
  }
}

import 'package:backrec_flutter/core/error/failures.dart';
import 'package:backrec_flutter/features/record/domain/usecases/start_recording.dart';
import 'package:backrec_flutter/features/record/domain/usecases/stop_recording.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
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
      if (event is StartRecordEvent) {
        emit(RecordingLoading());
        final result = await startRecording(null);
        _eitherFailureOrStarted(result);
      } else if (event is StopRecordEvent) {
        emit(RecordingLoading());
        final result = await stopRecording(null);
        _eitherFailureOrStopped(result);
      }
    });
  }

  void _eitherFailureOrStarted(Either<Failure, String> result) async {
    emit(result.fold(
      (failure) =>
          RecordingError(_mapFailureToMessage(failure)), //todo: map errors
      (series) => RecordingStarted(series),
    ));
  }

  void _eitherFailureOrStopped(Either<Failure, String> result) async {
    emit(result.fold(
      (failure) =>
          RecordingError(_mapFailureToMessage(failure)), //todo: map errors
      (series) => RecordingStopped(series),
    ));
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

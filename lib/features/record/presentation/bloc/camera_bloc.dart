import 'package:backrec_flutter/features/record/domain/usecases/init_camera.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final InitializeCamera initializeCamera;
  // final FocusCamera focusCamera;
  CameraBloc({required this.initializeCamera}) : super(CameraInitial()) {
    on<CameraEvent>((event, emit) async {
      if (event is InitializeRecordingEvent) {
        print("InitializeRecordingEvent");
        emit(CameraLoading());
        final result = await initializeCamera(Params(""));
        emit(result.fold(
          (failure) => CameraError(failure.toString()),
          (series) => CameraInitialized(series),
        ));
      } else if (event is CameraFocusEvent) {
        //TODO: focus camera
      }
    });
  }
}

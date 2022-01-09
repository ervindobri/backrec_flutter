part of 'camera_bloc.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraInitialized extends CameraState {
  final CameraController controller;
  CameraInitialized(this.controller);
}

class CameraFocused extends CameraState {}

class CameraError extends CameraState {
  final String message;

  CameraError(this.message);
}

part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class InitializeRecordingEvent extends CameraEvent {}
class CameraFocusEvent extends CameraEvent {
  final TapDownDetails details;
  final BoxConstraints constraints;

  CameraFocusEvent(this.details, this.constraints);
}

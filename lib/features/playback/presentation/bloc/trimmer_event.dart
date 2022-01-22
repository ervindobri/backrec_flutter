part of 'trimmer_bloc.dart';

abstract class TrimmerEvent extends Equatable {
  const TrimmerEvent();

  @override
  List<Object> get props => [];
}

class TrimVideo extends TrimmerEvent {
  final String video;
  final List<Marker> markers;

  TrimVideo({required this.video, required this.markers, });
}

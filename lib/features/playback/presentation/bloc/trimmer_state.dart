part of 'trimmer_bloc.dart';

abstract class TrimmerState extends Equatable {
  const TrimmerState();

  @override
  List<Object> get props => [];
}

class TrimmerInitial extends TrimmerState {}

class TrimmerTrimming extends TrimmerState {}

class TrimmerLoaded extends TrimmerState {
  //TODO: load back nr_marker * thumbnails;
}

class TrimmerError extends TrimmerState {}

part of 'trimmer_cubit.dart';

abstract class TrimmerState extends Equatable {
  const TrimmerState();

  @override
  List<Object> get props => [];
}

class TrimmerInitial extends TrimmerState {}
class TrimmerLoading extends TrimmerState {}
class TrimmerVideoLoaded extends TrimmerState {}
class TrimmerMarkersLoaded extends TrimmerState {}
class TrimmerTrimming extends TrimmerState {}
class TrimmerFinished extends TrimmerState {}

class TrimmerError extends TrimmerState {
  final String message;

  TrimmerError(this.message);
}

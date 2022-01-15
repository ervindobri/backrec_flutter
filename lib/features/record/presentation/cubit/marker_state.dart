part of 'marker_cubit.dart';

abstract class MarkerState extends Equatable {
  const MarkerState();

  @override
  List<Object> get props => [];
}

class MarkerInitial extends MarkerState {}
class MarkerLoading extends MarkerState {}
class MarkerLoaded extends MarkerState {}
class MarkerAdded extends MarkerState {}
class MarkerRemoved extends MarkerState {}
class MarkerSaved extends MarkerState {}

part of 'record_bloc.dart';

@immutable
abstract class RecordState {}

class RecordInitial extends RecordState {}
class RecordStarted extends RecordState {}
class RecordStopped extends RecordState {}
class RecordError extends RecordState {}

part of 'record_bloc.dart';

@immutable
abstract class RecordEvent {}

class StartRecordEvent extends RecordEvent {}

class StopRecordEvent extends RecordEvent {}

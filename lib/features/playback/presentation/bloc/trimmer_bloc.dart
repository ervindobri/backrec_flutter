import 'package:backrec_flutter/features/record/data/models/marker.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'trimmer_event.dart';
part 'trimmer_state.dart';

class TrimmerBloc extends Bloc<TrimmerEvent, TrimmerState> {
  TrimmerBloc() : super(TrimmerInitial()) {
    on<TrimmerEvent>((event, emit) {
      if (event is TrimVideo){
          //TODO: load video
          //TODO: trim video for each marker
          //TODO: save trimmed video pieces
      }
    });
  }
}

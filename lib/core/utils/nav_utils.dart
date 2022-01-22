import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/camera_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/record_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/timer_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/features/record/presentation/pages/record_screen.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavUtils {
  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  static void to(BuildContext context, Widget page) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                page));
  }

  static void toReplaced(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                page));
  }

  static void toRecording(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (
            context,
          ) =>
              MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    sl<CameraBloc>()..add(InitializeRecordingEvent()),
              ),
              BlocProvider(
                create: (context) => sl<PlaybackBloc>(),
              ),
              BlocProvider(
                create: (context) => sl<RecordBloc>(),
              ),
              BlocProvider(
                create: (context) => sl<TimerBloc>(),
              ),
              BlocProvider(
                create: (context) => sl<MarkerCubit>(),
              ),
            ],
            child: RecordScreen(),
          ),
        ));
  }
}

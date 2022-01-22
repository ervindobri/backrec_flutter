import 'package:backrec_flutter/core/constants/theme.dart';
import 'package:backrec_flutter/features/playback/presentation/bloc/playback_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/camera_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/record_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/bloc/timer_bloc.dart';
import 'package:backrec_flutter/features/record/presentation/cubit/marker_cubit.dart';
import 'package:backrec_flutter/features/record/presentation/pages/record_screen.dart';
import 'package:backrec_flutter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setEnabledOrientations();
  await di.init();
  runApp(MyApp());
}

Future<void> setEnabledOrientations() async {
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeRight,
  //   DeviceOrientation.landscapeLeft,
  // ]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'backREC',
      debugShowCheckedModeBanner: false,
      theme: BackrecTheme.theme,
      home: MultiBlocProvider(
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
    );
  }
}

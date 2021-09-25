import 'package:backrec_flutter/bloc/playback_bloc.dart';
import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/screens/record_screen.dart';
import 'package:backrec_flutter/services/playback_service.dart';
import 'package:backrec_flutter/services/record_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  final playbackService = PlaybackService();
  final recordService = RecordService();
  runApp(MyApp(
    playbackService: playbackService,
    recordService: recordService,
  ));
}

class MyApp extends StatelessWidget {
  final PlaybackService playbackService;
  final RecordService recordService;
  const MyApp(
      {Key? key, required this.playbackService, required this.recordService})
      : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'backREC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(TextTheme(
            bodyText1: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: GlobalColors.primaryGrey),
            bodyText2: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: GlobalColors.primaryGrey))),
        primarySwatch: Colors.red,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PlaybackBloc(
              service: playbackService,
              recordService: recordService,
            ),
          ),
          // BlocProvider(
          //   create: (context) => SubjectBloc(),
          // ),
        ],
        child: RepositoryProvider(
          create: (context) => playbackService,
          child: RecordScreen(),
        ),
      ),
    );
  }
}

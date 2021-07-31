import 'package:backrec_flutter/constants/global_colors.dart';
import 'package:backrec_flutter/screens/record_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


Future<void> main() async {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: RecordScreen(),
    );
  }
}

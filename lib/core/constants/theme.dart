import 'package:backrec_flutter/core/constants/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackrecTheme {
  BackrecTheme._();

  static ThemeData get theme => ThemeData(
      primaryColor: const Color(0xff202053),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: GlobalColors.textColor),
        titleTextStyle: GoogleFonts.poppins(
            color: GlobalColors.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff202053),
      ),
      textTheme: textTheme);

  static TextTheme get textTheme => TextTheme(
        caption: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.w400, color: GlobalColors.primaryGrey),
        subtitle1: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w500, color: GlobalColors.primaryGrey),
        subtitle2: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w400, color: GlobalColors.primaryGrey),
        bodyText1: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textColor),
        bodyText2: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: GlobalColors.textColor),
        headline6: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textColor),
        headline5: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textColor),
        headline4: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textColor),
        headline3: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textColor),
        headline2: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textColor),
        headline1: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textColor),
      );
}

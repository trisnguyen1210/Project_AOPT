import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle headingPurple = GoogleFonts.montserrat(
      fontSize: 17, color: Color(0xff316beb), fontWeight: FontWeight.w500);

  static TextStyle titlePurple = GoogleFonts.montserrat(
      fontSize: 14, color: Color(0xff316beb), fontWeight: FontWeight.w500);

  static TextStyle bodyPurple = GoogleFonts.montserrat(
      fontSize: 14, color: Color(0xff316beb), fontWeight: FontWeight.w400);

  static TextStyle superPurple = GoogleFonts.montserrat(
      fontSize: 50, color: Color(0xff316beb), fontWeight: FontWeight.w600);

  static TextStyle bodyBlueUnderline = GoogleFonts.montserrat(
      fontSize: 14,
      color: Color(0xff316beb),
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400);

  static TextStyle headingGrey = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.grey[700], fontWeight: FontWeight.w500);

  static TextStyle titleGrey = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500);

  static TextStyle bodyGrey = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w400);

  static TextStyle bodyGreyUnderline = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.grey[700],
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400);

  static TextStyle buttonText = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);

  static TextStyle textStyleStrike = GoogleFonts.montserrat(
      fontSize: 17,
      color: Colors.grey[700],
      decoration: TextDecoration.lineThrough,
      fontWeight: FontWeight.w400);

  static TextStyle textStyleRelation = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.grey[700], fontWeight: FontWeight.w400);

  static TextStyle bottomBarText =
      GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w400);

  static TextStyle tabText =
      GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.w500);

  static TextStyle hintGrey = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.grey[300], fontWeight: FontWeight.w400);
  static TextStyle textStyleGreyMedium = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.grey[700], fontWeight: FontWeight.w500);

  static TextStyle textStyleLarge = GoogleFonts.montserrat(
    fontSize: 38,
    color: Colors.grey[700],
    fontWeight: FontWeight.w600,
  );

  static TextStyle textStyleBold = GoogleFonts.montserrat(
    fontSize: 14,
    color: Colors.grey[700],
    fontWeight: FontWeight.w700,
  );
}

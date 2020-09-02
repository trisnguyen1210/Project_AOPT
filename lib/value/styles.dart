import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle textStyleSmall =
      GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w400);
  static TextStyle textStyleMedium = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.lightBlue[800], fontWeight: FontWeight.w500);

  static TextStyle textStyleBlue = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.lightBlue[800], fontWeight: FontWeight.w500);

  static TextStyle textStyleButton = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);

  static TextStyle textStyleUnderline = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.lightBlueAccent[400],
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400);

  static TextStyle textStyleTab =
      GoogleFonts.montserrat(fontSize: 17, fontWeight: FontWeight.w500);

  static TextStyle textStyleRelation = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.grey[700], fontWeight: FontWeight.w400);

  static TextStyle textStyleGreyNormal = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w400);

  static TextStyle textStyleGrey300Normal = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.grey[300], fontWeight: FontWeight.w400);

  static TextStyle textStyleGreyMedium = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.grey[700], fontWeight: FontWeight.w500);

  static TextStyle textStyleGreyMediumNormalSize = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w500);
}

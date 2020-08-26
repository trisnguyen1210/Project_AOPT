import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle textStyleSmall =
      GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w400);
  static TextStyle textStyleMedium = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.deepOrange[900], fontWeight: FontWeight.w500);

  static TextStyle textStyleButton = GoogleFonts.montserrat(
      fontSize: 14, color: Colors.brown[400], fontWeight: FontWeight.w600);

  static TextStyle textStyleUnderline = GoogleFonts.montserrat(
      fontSize: 14,
      color: Colors.lightBlueAccent[400],
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400);

  static TextStyle textStyleRelation = GoogleFonts.montserrat(
      fontSize: 17, color: Colors.grey[700], fontWeight: FontWeight.w400);
}

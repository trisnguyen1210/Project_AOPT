import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientApp {
  static Gradient gradientButton = LinearGradient(
      colors: [Color(0xfff784ff), Color(0xff3ad5ff)],
      stops: [0, 1],
      begin: Alignment(1.00, -0.00),
      end: Alignment(-1.00, 0.00));
}

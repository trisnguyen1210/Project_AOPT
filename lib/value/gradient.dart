import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientApp {
  static Gradient gradientButton = LinearGradient(
    colors: [Color(0xff17b1f4), Color(0xff3cd5ff)],
    stops: [0, 1],
    begin: Alignment(1.00, -0.00),
    end: Alignment(-1.00, 0.00),
    // angle: 270,
    // scale: undefined,
  );
}

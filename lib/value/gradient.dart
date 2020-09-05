import 'package:flutter/material.dart';

class GradientApp {
  static Gradient gradientButton = LinearGradient(
    colors: [Color(0xff653087), Color(0xffbe43a7)],
    stops: [0, 1],
    begin: Alignment(1.00, -0.00),
    end: Alignment(-1.00, 0.00),
    // angle: 270,
    // scale: undefined,
  );

  static Gradient gradientAppbar = LinearGradient(
    colors: [Color(0xffad499a), Color(0xffd54cc2), Color(0xff873182)],
    stops: [0, 0.3855574324324325, 1],
    begin: Alignment(1.00, -0.00),
    end: Alignment(-1.00, 0.00),
    // angle: 270,
    // scale: undefined,
  );
}

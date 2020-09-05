import 'dart:io';

import 'package:flutter/material.dart';

class Utils {
  static Widget getIconBack() {
    if (Platform.isAndroid) {
      return Icon(Icons.arrow_back);
    } else if (Platform.isIOS) {
      return Icon(Icons.arrow_back_ios);
    }
    return Icon(Icons.arrow_back);
  }
}

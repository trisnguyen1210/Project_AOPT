import 'dart:io';

import 'package:beans/widget/relation/confess/confess_success.dart';
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

  static void goToConfessSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ConfessSuccess()),
    );
  }

  static void setColorStatubBar() {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  static String getNumberAddZero(int number) {
    if (number == null) {
      return '00';
    }
    if (number < 10) {
      return '0' + number.toString();
    }
    return number.toString();
  }
}

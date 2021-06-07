import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:beans/widget/relation/confess/confess_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

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

  static void setColorStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
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

  static double getTargetWhiteBeanComplete(
      int whiteBeanCount, int currentWhiteBeanCount) {
    if (currentWhiteBeanCount == 0) return 0;
    if (currentWhiteBeanCount / whiteBeanCount > 1) return 100;
    return currentWhiteBeanCount / whiteBeanCount * 100;
  }

  static double getTargetBlackBeanComplete(
      int blackBeanCount, int currentBlackBeanCount) {
    if (currentBlackBeanCount == 0) return 0;
    if (currentBlackBeanCount / blackBeanCount > 1) return 100;
    return currentBlackBeanCount / blackBeanCount * 100;
  }

  static List<CircularStackEntry> getChartDataBlackBean(
      int blackBeanCount, int currentBlackBeanCount) {
    Color dialColor = Color(0xff83380e);
    Color dialColor2 = Color(0xffe3e3e3);
    double current =
        getTargetBlackBeanComplete(blackBeanCount, currentBlackBeanCount);
    if (current < 100) {
      return <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              100 - current.toDouble(),
              dialColor2,
              rankKey: 'remaining',
            ),
            new CircularSegmentEntry(
              current.toDouble(),
              dialColor,
              rankKey: 'completed',
            )
          ],
          rankKey: 'progress',
        ),
      ];
    } else {
      return <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              current.toDouble(),
              dialColor,
              rankKey: 'completed',
            )
          ],
          rankKey: 'progress',
        ),
      ];
    }
  }

  static List<CircularStackEntry> getChartDataWhiteBean(
      int whiteBeanCount, int currentWhiteBeanCount) {
    Color dialColor = Color(0xfff6d76a);
    Color dialColor2 = Color(0xffe3e3e3);
    double current =
        getTargetWhiteBeanComplete(whiteBeanCount, currentWhiteBeanCount);
    if (current < 100) {
      return <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              100 - current.toDouble(),
              dialColor2,
              rankKey: 'remaining',
            ),
            new CircularSegmentEntry(
              current.toDouble(),
              dialColor,
              rankKey: 'completed',
            )
          ],
          rankKey: 'progress',
        ),
      ];
    } else {
      return <CircularStackEntry>[
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              current.toDouble(),
              dialColor,
              rankKey: 'completed',
            )
          ],
          rankKey: 'progress',
        ),
      ];
    }
  }

  static String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd.MM.yy');
    return formatter.format(now);
  }
}

import 'dart:async';

import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  _SplashScreenState() {
    _timer = new Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Center(
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 150, bottom: 23, left: 0, right: 0),
                      child: SvgPicture.asset(
                        R.ic_logo,
                        height: 122,
                      )),
                  Text(
                    'Thiên Chúa là Tình Yêu\n(1 Ga 4,8)',
                    style: Styles.textStyleGreyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Padding(
                    padding: EdgeInsets.only(bottom: 53, left: 48, right: 48),
                    child: Text(
                      'Skip',
                      style: Styles.bodyGreyUnderline,
                    )),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

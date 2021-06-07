import 'dart:async';

import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Timer _timer;
  GifController controller1, controller2, controller3, controller4;

  _SplashScreenState() {
    _timer = new Timer(const Duration(milliseconds: 4000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    controller1 = GifController(vsync: this);
    controller2 = GifController(vsync: this);
    controller4 = GifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller1.repeat(min: 0, max: 53, period: Duration(milliseconds: 200));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller2.repeat(min: 0, max: 13, period: Duration(milliseconds: 200));
      controller4.repeat(min: 0, max: 13, period: Duration(milliseconds: 200));
    });
    controller3 = GifController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Utils.setColorStatusBar();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Container(
          color: Colors.white,
          child: Center(
            child:
                /* GifImage(
            controller: controller2,
            image: AssetImage(R.slpash_gif),
          ),*/
                Image.asset(R.slpash_gif),
          )
          /*  Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 200, bottom: 0, left: 0, right: 0),
                    child: SvgPicture.asset(
                      R.ic_logo,
                      height: 122,
                    ),
                  ),

                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0,top:149, left: 48, right: 48),
                  child:  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'THE BEANS\n ',
                          style: Styles.headerSplashStyle,
                        ),
                        TextSpan(
                          text: 'Hộp Đậu Xét Mình',
                          style: Styles.bodyPurple,
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 33, left: 48, right: 48),
                  child: Text(
                    'Skip',
                    style: Styles.bodyGreyUnderline,
                  ),
                ),
              ),
            ),
          ],
        ),*/
          ),
    );
  }
}

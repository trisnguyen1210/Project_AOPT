import 'package:beans/generated/r.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../../../main.dart';

class ConfessSuccess extends StatefulWidget {
  ConfessSuccess({Key key}) : super(key: key);

  @override
  _ConfessSuccessState createState() => _ConfessSuccessState();
}

class _ConfessSuccessState extends State<ConfessSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, right: 19),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  R.ic_close,
                  height: 20,
                  color: Color(0xff316beb),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 25),
            child: SvgPicture.asset(R.ic_sucess, height: 114),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25, left: 70, right: 70),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Chúc mừng ',
                    style: Styles.headingGrey,
                  ),
                  TextSpan(
                    text: 'Thành ',
                    style: Styles.headingPurple,
                  ),
                  TextSpan(
                    text: 'đã xét mình xong hôm nay!',
                    style: Styles.headingGrey,
                  )
                ],
              ),
            ),
          ),
          wordOfGodView(),
        ],
      ),
    );
  }

  Widget wordOfGodView() {
    return Expanded(
      flex: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(R.background_god_png), fit: BoxFit.fitWidth)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 25),
              child: Text(
                'Lời Chúa hôm nay:',
                style: Styles.headingExtraWhite,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15, left: 30, right: 30),
              child: Text(
                'Anh em hãy sẵn sàng, vì chính giờ phút anh em không ngờ Con Người sẽ đến - Mt 24,44 -',
                style: Styles.bodyWhite,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GradientButton(
                  increaseWidthBy: 40,
                  increaseHeightBy: 7.0,
                  callback: () {},
                  gradient: GradientApp.gradientButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      Text("Chia sẻ", style: Styles.buttonText)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

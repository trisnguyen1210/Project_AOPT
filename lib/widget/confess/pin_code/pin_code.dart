import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/custom/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../list/confess_list.dart';

class PinCodeScreen extends StatefulWidget {
  PinCodeScreen({Key key}) : super(key: key);

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Utils.setColorStatubBar();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: createAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 47, bottom: 25),
              child: SvgPicture.asset(R.ic_pin, height: 120),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0, left: 38, right: 38),
              child: Text(
                'Để xem bản xét mình, Thành hãy nhập mã pin của mình vào bên dưới nhé!',
                style: Styles.bodyGrey,
                textAlign: TextAlign.center,
              ),
            ),
            PinCodeTextField(
              length: 4,
              obscureText: true,
              mainAxisAlignment: MainAxisAlignment.center,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldHeight: 30,
                fieldWidth: 30,
                activeFillColor: Colors.white,
                selectedColor: Colors.white,
                inactiveColor: Colors.white,
                disabledColor: Colors.white,
                activeColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: false,
              onCompleted: (v) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfessList()),
                );
              },
              onChanged: (value) {
                print(value);
                setState(() {});
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
              appContext: context,
            )
          ],
        ),
      ),
    );
  }

  AppBar createAppbar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        'Bản xét mình',
        style: Styles.headingGrey,
      ),
      automaticallyImplyLeading: false,
    );
  }
}

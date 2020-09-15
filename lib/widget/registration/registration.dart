import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

import '../../main.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool monVal = false;
  String dropdownValue = '18 - 40 tuổi';

  @override
  Widget build(BuildContext context) {
    Utils.setColorStatubBar();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(top: 55, left: 35, right: 35, bottom: 35),
        child: Column(
          children: [
            createTitle(),
            createTextFieldName(),
            createDropDownAge(),
            createViewPin(),
                createViewPinRetype(),
                createTerm(),
                createButtonDone()
              ],
            ),
          )),
    );
  }

  Widget createTextFieldName() {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biệt danh/ tên của bạn",
              style: Styles.titleGrey,
              textAlign: TextAlign.left,
            ),
            TextField(
              cursorColor: Color(0xff9b3790),
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff9b3790))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  Widget createDropDownAge() {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Độ tuổi",
                style: Styles.titleGrey,
                textAlign: TextAlign.left,
              ),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff9b3790),
                ),
                elevation: 16,
                isExpanded: true,
                style: Styles.bodyGrey,
                underline: Container(height: 2, color: Color(0xff9b3790)),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['12 - 17 tuổi', '18 - 40 tuổi', 'Trên 40 tuổi']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: Styles.bodyGrey),
                  );
                }).toList(),
              ),
            ],
          ),
        ));
  }

  Widget createViewPin() {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhập mã pin",
              style: Styles.titleGrey,
              textAlign: TextAlign.left,
            ),
            TextField(
              cursorColor: Color(0xff9b3790),
              obscureText: true,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff9b3790))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  Widget createViewPinRetype() {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhập lại mã pin",
              style: Styles.titleGrey,
              textAlign: TextAlign.left,
            ),
            TextField(
              cursorColor: Color(0xff9b3790),
              obscureText: true,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff9b3790))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  Widget createTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: Text(
        'Để bảo mật và lựa chọn cách  xét mình thích hợp bạn hãy điền vào chỗ trống',
        style: Styles.headingPurple,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget createTerm() {
    return InkWell(
        onTap: () {
          setState(() {
            monVal = !monVal;
          });
        },
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: 15.0,
                      width: 15.0,
                      child: Checkbox(
                        value: monVal,
                        onChanged: (bool value) {
                          setState(() {
                            monVal = value; // rebuilds with new value
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 9),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Đọc và đồng ý ',
                              style: Styles.bodyGrey,
                            ),
                            TextSpan(
                              text: 'điều khoản và bảo mật',
                              style: Styles.bodyPurple,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget createButtonDone() {
    return Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 40),
        child: GradientButton(
          increaseWidthBy: 80,
          increaseHeightBy: 7.0,
          callback: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          gradient: GradientApp.gradientButton,
          child: Text("Xong", style: Styles.buttonText),
        ));
  }
}

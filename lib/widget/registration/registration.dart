import 'package:beans/utils/utils.dart';
import 'package:beans/model/user.dart';
import 'package:beans/provider/registration_provider.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Utils.setColorStatubBar();
    final registrationProvider = Provider.of<RegistrationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(top: 55, left: 35, right: 35, bottom: 35),
        child: Column(
          children: [
            createTitle(),
            createTextFieldName(registrationProvider),
            createDropDownAge(registrationProvider),
            createViewPin(registrationProvider),
            createViewPinRetype(registrationProvider),
            createTerm(registrationProvider),
            createButtonDone(registrationProvider),
          ],
        ),
      )),
    );
  }

  Widget createTextFieldName(RegistrationProvider registration) {
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
              cursorColor: Color(0xff316beb),
              onChanged: (value) => registration.name = value,
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff316beb))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  Widget createDropDownAge(RegistrationProvider registration) {
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
              DropdownButton<AgeRange>(
                value: registration.ageRange,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xff316beb),
                ),
                elevation: 16,
                isExpanded: true,
                style: Styles.bodyGrey,
                underline: Container(height: 2, color: Color(0xff316beb)),
                onChanged: (AgeRange newValue) =>
                    registration.ageRange = newValue,
                items: [AgeRange.from12To17, AgeRange.from18To40, AgeRange.gt40]
                    .map<DropdownMenuItem<AgeRange>>((AgeRange value) {
                  return DropdownMenuItem<AgeRange>(
                    value: value,
                    child: Text(
                      '${value.toShortString()} tuổi',
                      style: Styles.bodyGrey,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ));
  }

  Widget createViewPin(RegistrationProvider registration) {
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
              onChanged: (value) => registration.pin = value,
              cursorColor: Color(0xff316beb),
              obscureText: true,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff316beb))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  Widget createViewPinRetype(RegistrationProvider registration) {
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
              onChanged: (value) => registration.retypePin = value,
              cursorColor: Color(0xff316beb),
              obscureText: true,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff316beb))),
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
        'Để bảo mật và lựa chọn cách xét mình thích hợp bạn hãy điền vào chỗ trống',
        style: Styles.headingPurple,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget createTerm(RegistrationProvider registration) {
    return InkWell(
      onTap: () => registration.acceptTerm = !registration.acceptTerm,
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
                      value: registration.acceptTerm,
                      onChanged: (bool value) =>
                          registration.acceptTerm = value,
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
      ),
    );
  }

  Widget createButtonDone(RegistrationProvider registration) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 40),
      child: GradientButton(
        increaseWidthBy: 80,
        increaseHeightBy: 7.0,
        callback: registration.register,
        isEnabled: registration.isValid,
        gradient: GradientApp.gradientButton,
        child: Text("Xong", style: Styles.buttonText),
      ),
    );
  }
}

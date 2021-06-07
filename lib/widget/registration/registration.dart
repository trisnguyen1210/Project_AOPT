import 'package:beans/provider/registration_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Utils.setColorStatusBar();
    final registrationProvider = Provider.of<RegistrationProvider>(context);
    final node = FocusScope.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(top: 55, left: 35, right: 35, bottom: 35),
        child: Column(
          children: [
            createHeading(),
            createTitle(),
            createTextFieldName(registrationProvider, node),
            createDropDownAge(registrationProvider, context),
            createTextFieldEmail(registrationProvider, node),
            createViewPin(registrationProvider, node),
            createViewPinRetype(registrationProvider, node),
            createTerm(registrationProvider),
            createButtonDone(registrationProvider),
          ],
        ),
      )),
    );
  }

  Widget createTextFieldEmail(
      RegistrationProvider registration, FocusScopeNode node) {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Email',
                    style: Styles.titleGreyBold,
                  ),
                ],
              ),
            ),
            TextField(
              cursorColor: Color(0xff88674d),
              onChanged: (value) => registration.email = value,
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => node.nextFocus(),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff88674d))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  Widget createTextFieldName(
      RegistrationProvider registration, FocusScopeNode node) {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Biệt danh/ tên của bạn ',
                    style: Styles.titleGreyBold,
                  ),
                  TextSpan(
                    text: '(không quá 10 kí tự)',
                    style: Styles.subtitleGrey,
                  ),
                ],
              ),
            ),
            TextField(
              cursorColor: Color(0xff88674d),
              onChanged: (value) => registration.name = value,
              keyboardType: TextInputType.name,
              maxLines: 1,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => node.nextFocus(),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff88674d))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context, RegistrationProvider registration) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context, registration);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context, registration);
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(
      BuildContext context, RegistrationProvider registration) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      helpText: 'Sinh Nhật',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      errorFormatText: 'Ngày nhập phải hợp lệ',
      errorInvalidText: 'Ngày nhập phải trong khoảng thời gian cho phép',
      fieldLabelText: 'Sinh Nhật',
      fieldHintText: 'dd/MM/yyyy',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.brown,
              primaryColorDark: Colors.brown,
              accentColor: Colors.brown,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setValueTextController(registration);
    }
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(
      BuildContext context, RegistrationProvider registration) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate) {
                  selectedDate = picked;
                  setValueTextController(registration);
                }
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  var textController = new TextEditingController();

  void setValueTextController(RegistrationProvider registration) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
    textController.text = "$formattedDate";
    registration.bod = "$formattedDate";
  }

  Widget createDropDownAge(
      RegistrationProvider registration, BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Sinh nhật ',
                      style: Styles.titleGreyBold,
                    ),
                    TextSpan(
                      text: '(để app tìm cách xét mình phù hợp)',
                      style: Styles.subtitleGrey,
                    )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    _selectDate(context, registration);
                  },
                  child: TextField(
                    focusNode: FocusNode(),
                    enableInteractiveSelection: false,
                    enabled: false,
                    controller: textController,
                    cursorColor: Color(0xff88674d),
                    onChanged: (value) => registration.bod = value,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintStyle: Styles.hintGrey,
                      hintText: 'DD/MM/YYYY',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffcfcfcf))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff88674d))),
                      //Change this value to custom as you like
                    ),
                    style: Styles.bodyGrey,
                  )),
            ],
          ),
        ));
  }

  Widget createViewPin(RegistrationProvider registration, FocusScopeNode node) {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhập mã pin",
              style: Styles.titleGreyBold,
              textAlign: TextAlign.left,
            ),
            TextField(
              maxLength: 4,
              onChanged: (value) => registration.pin = value,
              cursorColor: Color(0xff88674d),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLines: 1,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              // Move focus to next
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff88674d))),
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            )
          ],
        ));
  }

  Widget createViewPinRetype(
      RegistrationProvider registration, FocusScopeNode node) {
    return Padding(
        padding: EdgeInsets.only(bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhập lại mã pin",
              style: Styles.titleGreyBold,
              textAlign: TextAlign.left,
            ),
            TextField(
              maxLength: 4,
              onChanged: (value) => registration.retypePin = value,
              cursorColor: Color(0xff88674d),
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => node.unfocus(),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcfcfcf))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff88674d))),
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
        style: Styles.bodyGrey,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget createHeading() {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Text(
        'THÔNG TIN CÁ NHÂN',
        style: Styles.extraHeadingPurple,
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
        elevation: 0,
        callback: registration.register,
        isEnabled: registration.isValid,
        gradient: GradientApp.gradientButton,
        child: Text("Xong", style: Styles.buttonText),
      ),
    );
  }
}

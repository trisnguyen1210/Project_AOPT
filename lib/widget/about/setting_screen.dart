import 'package:beans/generated/r.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(
            elevation: 0,
            brightness: Brightness.light,
            gradient: GradientApp.gradientAppbar,
            leading: IconButton(
              icon: Utils.getIconBack(),
              color: Color(0xff88674d),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: false,
            titleSpacing: 0.0,
            title: Text("CÀI ĐẶT & BẢO MẬT", style: Styles.headingBoldPurple)),
        body: Column(
          children: [
            editName(context),
            editBirthDay(context),
            editPassword(context),
            // editFontSize(),
            deleteData()
          ],
        ),
      ),
    );
  }

  var textControllerName = new TextEditingController();
  var textControllerBirthday = new TextEditingController();
  var textControllerPassword = new TextEditingController();
  var textControllerFontSize = new TextEditingController();

  Widget editName(BuildContext context) {
    final userName = Provider.of<AuthProvider>(context, listen: false).name;
    textControllerName.text = userName;
    return ListTile(
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12, // space between two icons
        children: <Widget>[
          IntrinsicWidth(
            child: TextField(
              controller: textControllerName,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              enabled: false,
              cursorColor: Color(0xff88674d),
              onChanged: (value) => {textControllerName.text = value},
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            ),
          ),
          SvgPicture.asset(R.ic_edit, color: Color(0xff88674d)),
        ],
      ),
      title: Text(
        'Tên/ Biệt Danh',
        style: Styles.headingGrey,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget editBirthDay(BuildContext context) {
    final dob = Provider.of<AuthProvider>(context, listen: false).dob;
    textControllerBirthday.text = dob;
    return ListTile(
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12, // space between two icons
        children: <Widget>[
          IntrinsicWidth(
            child: TextField(
              controller: textControllerBirthday,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              enabled: false,
              cursorColor: Color(0xff88674d),
              onChanged: (value) => {textControllerBirthday.text = value},
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            ),
          ),
          SvgPicture.asset(R.ic_edit, color: Color(0xff88674d)),
        ],
      ),
      title: Text(
        'Sinh nhật',
        style: Styles.headingGrey,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget editPassword(BuildContext context) {
    final pin = Provider.of<AuthProvider>(context, listen: false).pin;
    textControllerPassword.text = pin;
    return ListTile(
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12, // space between two icons
        children: <Widget>[
          IntrinsicWidth(
            child: TextField(
              controller: textControllerPassword,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              enabled: false,
              cursorColor: Color(0xff88674d),
              onChanged: (value) => {textControllerPassword.text = value},
              keyboardType: TextInputType.visiblePassword,
              maxLines: 1,
              obscureText: true,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            ),
          ),
          SvgPicture.asset(R.ic_edit, color: Color(0xff88674d)),
        ],
      ),
      title: Text(
        'Mã pin',
        style: Styles.headingGrey,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget editFontSize() {
    textControllerFontSize.text = "14";
    return ListTile(
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12, // space between two icons
        children: <Widget>[
          IntrinsicWidth(
            child: TextField(
              controller: textControllerFontSize,
              focusNode: FocusNode(),
              enableInteractiveSelection: false,
              enabled: false,
              cursorColor: Color(0xff88674d),
              onChanged: (value) => {textControllerFontSize.text = value},
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                //Change this value to custom as you like
              ),
              style: Styles.bodyGrey,
            ),
          ),
          SvgPicture.asset(R.ic_edit, color: Color(0xff88674d)),
        ],
      ),
      title: Text(
        'Độ lớn của chữ',
        style: Styles.headingGrey,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget deleteData() {
    return ListTile(
        title: GestureDetector(
      onTap: () {
        DefaultCacheManager().emptyCache();
      },
      child: Text(
        'Xoá toàn bộ dữ liệu',
        style: Styles.headingRed,
        textAlign: TextAlign.start,
      ),
    ));
  }
}

import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main.dart';

class ConfessDone extends StatefulWidget {
  ConfessDone({Key key}) : super(key: key);

  @override
  _ConfessDoneState createState() => _ConfessDoneState();
}

class _ConfessDoneState extends State<ConfessDone> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Utils.setColorStatusBar();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: createAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: 29, left: 40, right: 40, bottom: 2),
                child: Text(
                  'Thành có cảm thấy người nhẹ đi 100kg sau khi xưng tội xong không?',
                  style: Styles.bodyGrey,
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 33),
              child: Text(
                'Chúc mừng',
                style: Styles.titlePurple,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 33),
              child: SvgPicture.asset(R.ic_confess_done, height: 126),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 30, left: 40, right: 40),
                child:
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Styles.bodyGrey,
                    children: [
                      TextSpan(
                          text: 'Bản xét mình của Thành vừa được xoá, bạn hãy làm việc đền tội trong 24 giờ và nhấn hoàn thành để nhận 2 đậu trắng nhé! '),
                      WidgetSpan(
                        child: Image(
                          image: AssetImage(R.tooltip),
                          height: 28,
                          width: 28,
                        ),
                      ),
                    ],
                  ),
                )
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
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close, color: Color(0xffdfdddd), size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ],
    );
  }
}

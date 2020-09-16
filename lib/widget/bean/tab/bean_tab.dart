import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BeanTab extends StatefulWidget {
  BeanTab({Key key}) : super(key: key);

  @override
  _BeanTabState createState() => _BeanTabState();
}

class _BeanTabState extends State<BeanTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 30, left: 59, right: 59, bottom: 30),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Thành đang có\n',
                      style: Styles.bodyGrey,
                    ),
                    TextSpan(
                      text: '300\n',
                      style: Styles.superPurple,
                    ),
                    TextSpan(
                      text: 'hạt đậu biết ơn!',
                      style: Styles.bodyGrey,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 41),
              child: SvgPicture.asset(R.ic_white_bean, height: 113),
            ),
            Padding(
                padding: EdgeInsets.only(left: 48, right: 48),
                child: Text("Mục tiêu 3 tháng: 450 hạt",
                    style: Styles.bodyGrey, textAlign: TextAlign.center)),
            Padding(
                padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
                child: Text("Đã hoàn thành 70% mục tiêu",
                    style: Styles.bodyGrey, textAlign: TextAlign.center)),
            Padding(
              padding: EdgeInsets.only(bottom: 31, left: 60, right: 60),
              child: LinearPercentIndicator(
                lineHeight: 13.0,
                percent: 0.5,
                backgroundColor: Color(0xffdddddd),
                progressColor: Color(0xff316beb),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 0, left: 48, right: 48),
                child: Text(
                  'Xem hủ trăn trở',
                  style: Styles.bodyGreyUnderline,
                )),
            Padding(
                padding: EdgeInsets.only(bottom: 8, left: 48, right: 48),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[700],
                )),
          ],
        ),
      )),
    );
  }
}

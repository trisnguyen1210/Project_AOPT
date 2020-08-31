import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class RelationDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        gradient: LinearGradient(
            colors: [Colors.lightBlue[400], Colors.lightBlueAccent[200]]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Beans'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tôi ',
                            style: Styles.textStyleMedium,
                          ),
                          WidgetSpan(
                            child: SvgPicture.asset(R.ic_health, height: 24),
                          ),
                          TextSpan(
                            text: 'Khả năng & Sức khoẻ',
                            style: Styles.textStyleRelation,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text('Đối với sức khoẻ của tôi hôm nay',
                          style: Styles.textStyleGreyMedium),
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0.2701590401785715,
              child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff979797), width: 1))),
            ),
          ],
        ),
      ),
    );
  }
}

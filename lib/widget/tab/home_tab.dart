import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/relation_detail/relation_detail.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class HomeTab extends StatelessWidget {
  final List<String> listRelation = <String>['Tôi', 'Tha nhân', 'Chúa'];
  final List<String> listIconRelation = <String>[
    R.ic_myself,
    R.ic_other_guys,
    R.ic_god
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          titleTop(),
          getListRelation(),
          divider(),
          titleChallenge(),
          challengeText(),
          buttonChallenge(),
          anotherChallengeText(),
        ],
      ),
    );
  }

  Widget buttonChallenge() {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: GradientButton(
          increaseWidthBy: 125,
          increaseHeightBy: 7.0,
          callback: () {},
          gradient: LinearGradient(
              colors: [Color(0xfff784ff), Color(0xff3ad5ff)],
              stops: [0, 1],
              begin: Alignment(1.00, -0.00),
              end: Alignment(-1.00, 0.00)),
          child: Text("Chấp nhận thử thách", style: Styles.textStyleButton),
        )
    );
  }

  Widget divider() {
    return Opacity(
      opacity: 0.3,
      child: Container(
          height: 1,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff979797), width: 1))),
    );
  }

  Widget getListRelation() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: GridView.builder(
        itemCount: listRelation.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) =>
            getItemRelation(index, context),
      ),
    );
  }

  Widget challengeText() {
    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Text('"Gửi một tấm thiệp cám ơn"',
            style: Styles.textStyleRelation, textAlign: TextAlign.center));
  }

  Widget anotherChallengeText() {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Tìm thử thách khác',
            style: Styles.textStyleUnderline, textAlign: TextAlign.center));
  }

  Widget getItemRelation(int index, BuildContext context) {
    return

      GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => RelationDetail()),
            );
          },
          // The custom button
          child: Column(
            children: [
              //SvgPicture.asset(listIconRelation[index], height: 85, width: 85),
              Image(
                width: 85,
                height: 85,
                image: AssetImage(listIconRelation[index]),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Text(
                      listRelation[index], style: Styles.textStyleRelation))
            ],
          )
      );
  }

  Column titleTop() {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.only(left: 37, right: 37, top: 30, bottom: 41),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Styles.textStyleMedium,
              children: [
                TextSpan(
                    text: 'Mối tương quan nào bạn muốn xét lại hôm nay?  '),
                WidgetSpan(
                  child: Image(
                    image: AssetImage(R.tooltip),
                    height: 28,
                    width: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column titleChallenge() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Styles.textStyleMedium,
              children: [
                TextSpan(text: 'Thử thách 24 giờ  '),
                WidgetSpan(
                  child: Image(
                    image: AssetImage('assets/tooltip.png'),
                    height: 28,
                    width: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

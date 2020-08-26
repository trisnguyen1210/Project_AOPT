import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTab extends StatelessWidget {
  final List<String> listRelation = <String>['Tôi', 'Tha nhân', 'Chúa'];
  final List<String> listIconRelation = <String>[
    R.ic_my_self,
    R.ic_other_guys,
    R.ic_god
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        titleTop(),
        getListRelation(),
        divider(),
        titleChallenge(),
        challengeText(),
        buttonChallenge(),
        anotherChallengeText()
      ],
    );
  }

  Widget buttonChallenge() {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          margin: const EdgeInsets.only(left: 80, right: 80),
          height: 37,
          child: RaisedButton(
            color: Colors.amber[300],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.5),
                side: BorderSide(color: Colors.amber[300])),
            onPressed: () {},
            child: Text("Chấp nhận thử thách", style: Styles.textStyleButton),
          ),
        ));
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
            getItemRelation(index),
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

  Widget getItemRelation(int index) {
    return Column(
      children: [
        SvgPicture.asset(listIconRelation[index], height: 85, width: 85),
        Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Text(listRelation[index], style: Styles.textStyleRelation))
      ],
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
import 'dart:ui';

import 'package:beans/generated/r.dart';
import 'package:beans/provider/challenge_provider.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/challenge/challenge_view.dart';
import 'package:beans/widget/relation/relation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          ChangeNotifierProvider(
            create: (context) => ChallengeProvider(),
            child: ChallengeView(),
          ),
        ],
      ),
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
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 30),
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

  Widget getItemRelation(int index, BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RelationList()),
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
                padding: const EdgeInsets.only(top: 14),
                child:
                    Text(listRelation[index], style: Styles.textStyleRelation))
          ],
        ));
  }

  Column titleTop() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 27),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'XÉT MÌNH\n',
                  style: Styles.extraHeadingPurple,
                ),
                TextSpan(
                  text: 'NGÀY 12.09.20',
                  style: Styles.dateStyle,
                ),
              ],
            ),
          ),
        ), Padding(
          padding:
          const EdgeInsets.only(left: 20, right: 20, top: 9, bottom: 43),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Styles.titleGrey,
              children: [
                TextSpan(
                    text: 'Mối tương quan nào khiến Thành băn khoăn hay hạnh phúc nhất hôm nay? '),
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
}

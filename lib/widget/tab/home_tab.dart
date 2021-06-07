import 'dart:ui';

import 'package:beans/model/relational_category.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:beans/provider/challenge_provider.dart';
import 'package:beans/provider/relation_list_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/about/about_beans.dart';
import 'package:beans/widget/challenge/challenge_view.dart';
import 'package:beans/widget/relation/relation_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<AuthProvider>(context, listen: false).name;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: createAppbar(userName, context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            titleTop(userName),
            godWordText(),
            Provider(
              create: (context) => RelationListProvider(),
              child: getListRelation(),
            ),
            ChangeNotifierProvider(
              create: (context) => ChallengeProvider(),
              child: ChallengeView(),
            ),
          ],
        ),
      ),
      // TODO: Not implemnet yet
      // endDrawer: SlidingMenu(),
    );
  }

  Widget godWordText() {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 30),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '“Bình an cho anh em”(Lc 24, 36)',
              style: Styles.headingPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget getListRelation() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      child: Consumer<RelationListProvider>(
        builder: (context, value, child) => FutureBuilder(
          future: value.fetchCategories(),
          initialData: List<RelationalCategory>(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final List<RelationalCategory> categories = snapshot.data;

            return GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: categories
                  .asMap()
                  .map((i, cat) =>
                      MapEntry(i, getItemRelation(context, categories, i)))
                  .values
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget getItemRelation(
    BuildContext context,
    List<RelationalCategory> categories,
    int currentCategoryIndex,
  ) {
    final category = categories[currentCategoryIndex];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RelationList(categories: categories)),
        );
      },
      // The custom button
      child: Column(
        children: [
          Image(
            width: 85,
            height: 85,
            image: AssetImage(category.icon),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(category.name, style: Styles.textStyleRelation))
        ],
      ),
    );
  }

  GradientAppBar createAppbar(String name, BuildContext context) {
    return GradientAppBar(
      brightness: Brightness.light,
      elevation: 1,
      centerTitle: false,
      titleSpacing: 0.0,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutBeans(),
              ),
            );
          },
          child: Icon(Icons.more_vert, color: Color(0xff88674d), size: 36.0),
        )
      ],
      title: Container(
        margin: EdgeInsets.only(left: 16),
        child: Text(
          'Hộp Đậu của $name',
          style: Styles.headingPurple,
        ),
      ),
      gradient: GradientApp.gradientAppbar,
      automaticallyImplyLeading: false,
    );
  }

  Column titleTop(String userName) {

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 27, bottom: 30),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'XÉT MÌNH\n',
                  style: Styles.extraHeadingPurple,
                ),
                TextSpan(
                  text: "NGÀY ${Utils.getCurrentDate()}",
                  style: Styles.dateStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

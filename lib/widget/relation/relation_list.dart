import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/relation/relation_tab/relation_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class RelationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: GradientAppBar(
              gradient: GradientApp.gradientAppbar,
              leading: IconButton(
                icon: Utils.getIconBack(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: false,
              titleSpacing: 0.0,
              title: Container(
                margin: EdgeInsets.only(left: 16),
                child: SvgPicture.asset(
                  R.ic_snowman,
                  width: 99,
                  height: 43,
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: Color(0xff9b3790),
                    labelColor: Color(0xff9b3790),
                    labelStyle: Styles.tabText,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.only(top: 10),
                    tabs: [
                      Tab(text: 'Tôi'),
                      Tab(text: 'Tha nhân'),
                      Tab(text: 'Chúa'),
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
                Expanded(
                  flex: 3,
                  child: TabBarView(
                    children: [
                      RelationTab(),
                      RelationTab(),
                      RelationTab(),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

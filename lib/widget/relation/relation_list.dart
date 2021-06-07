import 'package:beans/model/relational_category.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/relation/relation_tab/relation_tab.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class RelationList extends StatelessWidget {
  final List<RelationalCategory> categories;

  const RelationList({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: MaterialApp(
        home: DefaultTabController(
          length: categories.length,
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
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: Color(0xff88674d),
                    labelColor: Color(0xff88674d),
                    labelStyle: Styles.tabText,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.only(top: 10),
                    tabs: categories
                        .map((cat) => Tab(text: cat.name.toUpperCase()))
                        .toList(),
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
                  child: TabBarView(
                    children: categories
                        .map((cat) => RelationTab(category: cat))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

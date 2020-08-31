import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/relation/relation_tab/relation_tab.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class RelationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: GradientAppBar(
              gradient: LinearGradient(
                  colors: [Colors.lightBlue[400], Colors.lightBlueAccent[200]]),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text('Beans'),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: Colors.lightBlue[800],
                    labelColor: Colors.lightBlue[800],
                    labelStyle: Styles.textStyleTab,
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

import 'package:beans/value/styles.dart';
import 'package:beans/widget/bean/tab/bean_tab.dart';
import 'package:flutter/material.dart';

class MyBean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: Color(0xff88674d),
                    labelColor: Color(0xff88674d),
                    labelStyle: Styles.tabText,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.only(top: 10),
                    tabs: [
                      Tab(text: 'HŨ ĐẬU'),
                      Tab(text: 'MỤC TIÊU'),
                      Tab(text: 'BIỂU HIỆU'),
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
                  BeanTab(),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Đang xây dựng',
                          style: Styles.optionStyle,
                        ),
                      )
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Đang xây dựng',
                          style: Styles.optionStyle,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}

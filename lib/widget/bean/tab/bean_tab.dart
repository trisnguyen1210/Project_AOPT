import 'dart:async';

import 'package:beans/provider/auth_provider.dart';
import 'package:beans/provider/bean_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/styles.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class BeanTab extends StatefulWidget {
  BeanTab({Key key}) : super(key: key);

  @override
  _BeanTabState createState() => _BeanTabState();
}

class _BeanTabState extends State<BeanTab> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  final GlobalKey<AnimatedCircularChartState> _chartKey2 =
      new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(200.0, 200.0);

  Color labelColor = Color(0xffFFC269);
  bool monVal = false;

  // ScrollableState scrollable = Scrollable.of(context);
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: Column(
            children: [whiteBeanView(context), blackBeanView(context)],
          ),
        ),
      ),
    );
  }

  Widget blackBeanView(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final beanProvider = Provider.of<BeanProvider>(context);

    return Visibility(
        visible: monVal,
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 59, right: 59, bottom: 14),
              child: Text('HỦ ĐẬU TRĂN TRỞ',
                  style: Styles.headingExtraPurple,
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(left: 48, right: 48),
              child: Text(
                  "Thành đang có " +
                      authProvider.blackCount.toString() +
                      " hạt đậu trăn trở.\ngần chạm mức mục tiêu tối thiểu",
                  style: Styles.bodyGrey,
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
              child: AnimatedCircularChart(
                key: _chartKey2,
                size: _chartSize,
                initialChartData: Utils.getChartDataBlackBean(0, 0),
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                percentageValues: true,
                holeLabel: Utils.getTargetBlackBeanComplete(
                      beanProvider.target?.blackCount ?? 0,
                      authProvider.blackCount,
                    ).round().toString() +
                    "%",
                labelStyle: Theme.of(context)
                    .textTheme
                    .title
                    .merge(new TextStyle(color: Color(0xff7b4d0a))),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
                child: Text(
                    "Thời gian: " +
                        formatDate(DateTime.now(), [dd]) +
                        " ngày / 1 tháng",
                    style: Styles.bodyGrey,
                    textAlign: TextAlign.center)),
            Padding(
              padding: EdgeInsets.only(bottom: 31, left: 60, right: 60),
              child: LinearPercentIndicator(
                lineHeight: 13.0,
                percent: double.parse(formatDate(DateTime.now(), [dd])) / 30,
                backgroundColor: Color(0xffdddddd),
                progressColor: Color(0xff316beb),
              ),
            ),
          ],
        ));
  }

  Widget whiteBeanView(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final beanProvider = Provider.of<BeanProvider>(context);
    Timer _timer;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 59, right: 59, bottom: 14),
          child: Text('HỦ ĐẬU BIẾT ƠN',
              style: Styles.headingExtraPurple, textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.only(left: 48, right: 48),
          child: Text(
              "Thành đang có " +
                  authProvider.greenCount.toString() +
                  " hạt đậu biết ơn.",
              style: Styles.bodyGrey,
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
          child: AnimatedCircularChart(
            key: _chartKey,
            size: _chartSize,
            initialChartData: Utils.getChartDataWhiteBean(
                beanProvider.target?.greenCount ?? 0, authProvider.greenCount),
            chartType: CircularChartType.Radial,
            edgeStyle: SegmentEdgeStyle.round,
            percentageValues: true,
            holeLabel: Utils.getTargetWhiteBeanComplete(
                        beanProvider.target?.greenCount ?? 0,
                        authProvider.greenCount)
                    .round()
                    .toString() +
                "%",
            labelStyle: Theme.of(context)
                .textTheme
                .title
                .merge(new TextStyle(color: labelColor)),
          ),
        ),
        Consumer<BeanProvider>(builder: (context, beanProvider, child) {
          return Padding(
              padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
              child: Text(
                  "Hoàn thành " +
                      Utils.getTargetWhiteBeanComplete(
                              beanProvider.target?.greenCount ?? 0,
                              authProvider.greenCount)
                          .round()
                          .toString() +
                      "% mục tiêu",
                  style: Styles.bodyGrey,
                  textAlign: TextAlign.center));
        }),
        Padding(
            padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
            child: Text(
                "Thời gian: " +
                    formatDate(DateTime.now(), [dd]) +
                    " ngày / 1 tháng",
                style: Styles.bodyGrey,
                textAlign: TextAlign.center)),
        Padding(
          padding: EdgeInsets.only(bottom: 31, left: 60, right: 60),
          child: LinearPercentIndicator(
            lineHeight: 13.0,
            percent: double.parse(formatDate(DateTime.now(), [dd])) / 30,
            backgroundColor: Color(0xffdddddd),
            progressColor: Color(0xff316beb),
          ),
        ),
        InkWell(
            onTap: () {
              setState(() {
                monVal = !monVal;
                if (monVal) {
                  _timer = new Timer(const Duration(milliseconds: 100), () {
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                }
              });
            },
            child: Column(
              children: [
                Visibility(
                    visible: !monVal,
                    child: Column(
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(bottom: 0, left: 48, right: 48),
                            child: Text(
                              'Xem hủ trăn trở',
                              style: Styles.bodyGreyUnderline,
                            )),
                        Padding(
                            padding:
                                EdgeInsets.only(bottom: 8, left: 48, right: 48),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[700],
                            )),
                      ],
                    )),
                Visibility(
                    visible: monVal,
                    child: Column(
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(bottom: 8, left: 48, right: 48),
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.grey[700],
                            )),
                        Padding(
                            padding:
                                EdgeInsets.only(bottom: 0, left: 48, right: 48),
                            child: Text(
                              'Trở về hủ biết ơn',
                              style: Styles.bodyGreyUnderline,
                            )),
                      ],
                    )),
              ],
            )),
      ],
    );
  }
}

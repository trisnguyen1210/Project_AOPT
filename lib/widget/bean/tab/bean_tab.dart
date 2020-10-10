import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

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

  double value = 75.0;
  Color labelColor = Color(0xffFFC269);

  List<CircularStackEntry> _generateChartData(double value) {
    Color dialColor = Color(0xfff6d76a);
    Color dialColor2 = Color(0xffe3e3e3);
    labelColor = dialColor;

    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            25,
            dialColor2,
            rankKey: 'remaining',
          ),
          new CircularSegmentEntry(
            75,
            dialColor,
            rankKey: 'completed',
          )
        ],
        rankKey: 'progress',
      ),
    ];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context)
        .textTheme
        .title
        .merge(new TextStyle(color: labelColor));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 59, right: 59, bottom: 14),
              child: Text('HỦ ĐẬU BIẾT ƠN',
                  style: Styles.headingExtraPurple,
                  textAlign: TextAlign.center),
            ),
            Padding(
                padding: EdgeInsets.only(left: 48, right: 48),
                child: Text("Thành đang có 300 hạt đậu biết ơn.",
                    style: Styles.bodyGrey, textAlign: TextAlign.center)),
            Padding(
                padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
                child: AnimatedCircularChart(
                  key: _chartKey,
                  size: _chartSize,
                  initialChartData: _generateChartData(value),
                  chartType: CircularChartType.Radial,
                  edgeStyle: SegmentEdgeStyle.round,
                  percentageValues: true,
                  holeLabel: '$value%',
                  labelStyle: _labelStyle,
                )),
            Padding(
                padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
                child: Text("Hoàn thành 70% mục tiêu",
                    style: Styles.bodyGrey, textAlign: TextAlign.center)),
            Padding(
                padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
                child: Text("Thời gian: 10 ngày / 1 tháng",
                    style: Styles.bodyGrey, textAlign: TextAlign.center)),
            Padding(
              padding: EdgeInsets.only(bottom: 31, left: 60, right: 60),
                  child: LinearPercentIndicator(
                    lineHeight: 13.0,
                    percent: 0.5,
                    backgroundColor: Color(0xffdddddd),
                    progressColor: Color(0xff316beb),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 0, left: 48, right: 48),
                    child: Text(
                      'Xem hủ trăn trở',
                      style: Styles.bodyGreyUnderline,
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 48, right: 48),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[700],
                    )),

                Padding(
                  padding:
                  EdgeInsets.only(top: 20, left: 59, right: 59, bottom: 14),
                  child: Text('HỦ ĐẬU TRĂN TRỞ',
                      style: Styles.headingExtraPurple,
                      textAlign: TextAlign.center
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(left: 48, right: 48),
                    child: Text(
                        "Thành đang có 200 hạt đậu trăn trở.\ngần chạm mức mục tiêu tối thiểu",
                        style: Styles.bodyGrey, textAlign: TextAlign.center
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
                    child: AnimatedCircularChart(
                      key: _chartKey2,
                      size: _chartSize,
                      initialChartData: _generateChartData(value),
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
                      percentageValues: true,
                      holeLabel: '$value%',
                      labelStyle: _labelStyle,
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: 15, left: 48, right: 48),
                    child: Text("Thời gian: 10 ngày / 1 tháng",
                        style: Styles.bodyGrey, textAlign: TextAlign.center)),
                Padding(
                  padding: EdgeInsets.only(bottom: 31, left: 60, right: 60),
                  child: LinearPercentIndicator(
                    lineHeight: 13.0,
                    percent: 0.5,
                    backgroundColor: Color(0xffdddddd),
                    progressColor: Color(0xff316beb),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

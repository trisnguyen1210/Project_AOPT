import 'package:beans/generated/r.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/confess/done/confess_done.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class ConfessList extends StatefulWidget {
  ConfessList({Key key}) : super(key: key);

  @override
  _ConfessListState createState() => _ConfessListState();
}

class _ConfessListState extends State<ConfessList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 60, bottom: 0, left: 50, right: 50),
              child: Text('Bản xét mình của Thành',
                  style: Styles.headingPurple, textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15, left: 50, right: 50),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Từ ngày 11/7/20 tới hôm nay',
                      style: Styles.bodyGrey,
                    ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.only(right: 15, bottom: 0),
                    child: SvgPicture.asset(
                      R.ic_plus,
                      width: 18,
                      height: 18,
                    )),
                Padding(
                    padding: EdgeInsets.only(right: 19),
                    child: SvgPicture.asset(
                      R.ic_minus,
                      width: 18,
                      height: 18,
                    )),
              ],
            ),
            createButtonAddDelete(),
            createListRelation(),
            createButtonDone()
          ],
        ),
      ),
    );
  }

  Widget createButtonAddDelete() {
    return Padding(
      padding: EdgeInsets.only(top: 13, bottom: 10),
      child: Opacity(
        opacity: 0.2701590401785715,
        child: Container(
            height: 1,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff979797), width: 1))),
      ),
    );
  }

  Widget createListRelation() {
    return Padding(
      padding: EdgeInsets.only(left: 26, right: 26),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            RelationItem(data[index], index, data.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
      ),
    );
  }

  Widget createButtonDone() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, top: 20),
      child: GradientButton(
        increaseWidthBy: 90,
        increaseHeightBy: 7.0,
        callback: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfessDone()),
          );
        },
        gradient: GradientApp.gradientButton,
        child: Text("Xưng tội xong", style: Styles.buttonText),
      ),
    );
  }
}

class Relation {
  Relation(this.title, [this.beans = const <Bean>[]]);

  final String title;
  final List<Bean> beans;
}

class Bean {
  Bean(this.title, this.count);

  final String title;
  final int count;
}

List<Relation> data = <Relation>[
  Relation(
    'Đối với bản thân',
    <Bean>[
      Bean('Tôi không bảo vệ sức khoẻ', 10),
      Bean('Tôi không bảo vệ sức khoẻ', 10),
      Bean('Tôi không bảo vệ sức khoẻ', 10),
    ],
  ),
  Relation(
    'Đối với người khác',
    <Bean>[
      Bean('Tôi không bảo vệ sức khoẻ', 10),
      Bean('Tôi không bảo vệ sức khoẻ', 10),
      Bean('Tôi không bảo vệ sức khoẻ', 10),
    ],
  ),
  Relation(
    'Đối với Chúa',
    <Bean>[
      Bean('Tôi không bảo vệ sức khoẻ', 10),
      Bean('Tôi không bảo vệ sức khoẻ', 10),
      Bean('Tôi không bảo vệ sức khoẻ', 10),
    ],
  ),
];

class RelationItem extends StatelessWidget {
  const RelationItem(this.relation, this.position, this.size);

  final Relation relation;
  final int position;
  final int size;

  Widget _buildTiles(Relation root, int position, BuildContext context) {
    return createParenItem(root, position, context);
  }

  Widget createParenItem(Relation root, int position, BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(bottom: 12, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(root.title, style: Styles.titleGrey),
                  Text('Lần', style: Styles.titleGrey),
                ],
              ),
            )),
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                BeanItem(root.beans[index], index, root.beans.length),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: root.beans.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(relation, position, context);
  }
}

class BeanItem extends StatefulWidget {
  BeanItem(this.bean, this.position, this.size);

  Bean bean;
  int position;
  int size;

  @override
  _BeanItem createState() => _BeanItem(bean, position, size);
}

class _BeanItem extends State<BeanItem> {
  _BeanItem(this.bean, this.position, this.size);

  Bean bean;
  int position;
  int size;
  bool monVal = false;

  Widget _buildTiles(Bean root, int position, BuildContext context) {
    return createChildItem(root, position, context);
  }

  Widget createChildItem(Bean root, int position, BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            monVal = !monVal;
          });
        },
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 15.0,
                          width: 15.0,
                          child: Checkbox(
                            value: monVal,
                            onChanged: (bool value) {
                              setState(() {
                                monVal = value; // rebuilds with new value
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 9),
                          child: Text(
                            root.title,
                            style: Styles.bodyGrey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "x" + root.count.toString(),
                      style: Styles.bodyGrey,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(bean, position, context);
  }
}

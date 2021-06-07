import 'package:beans/generated/r.dart';
import 'package:beans/model/confession.dart';
import 'package:beans/provider/confess_provider.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/confess/done/confess_done.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

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
          child:
          ChangeNotifierProvider<ConfessProvider>(
            create: (context) => ConfessProvider(),
            child:
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: 60, bottom: 0, left: 50, right: 50),
                  child: Text('BẢN XÉT MÌNH',
                      style: Styles.extraHeadingPurple,
                      textAlign: TextAlign.center),
                ),

                Consumer<ConfessProvider>(
                    builder: (context, confessProvider, child) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 15, left: 50, right: 50),
                        child: RichText(
                          text: TextSpan(
                            children: [

                              TextSpan(
                                text: 'Từ ngày ' + confessProvider.dateFrom +
                                    ' tới hôm nay',
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
                      );
                    }
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
          )


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
    return Consumer<ConfessProvider>(
        builder: (context, confessProvider, child) {
          if (confessProvider.listConfess.isEmpty) {
            return creatEmptyView();
          }
          return Padding(
            padding: EdgeInsets.only(left: 26, right: 26),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  RelationItem(
                      confessProvider.listConfess.values.elementAt(index),
                      index, confessProvider.listConfess.keys.length),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: confessProvider.listConfess.keys.length,
            ),
          );
        }
    );
  }

  Widget creatEmptyView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 26, right: 26, top: 42, bottom: 26),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: SvgPicture.asset(
                R.ic_empty_list,
                width: 77,
                height: 77,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Thành chưa có điều gì để xưng tội.\nHãy ',
                    style: Styles.bodyGrey,
                  ),
                  TextSpan(
                    text: 'quay về nhà ',
                    style: Styles.bodyPurple,
                  ),
                  TextSpan(
                    text: 'xét mình!',
                    style: Styles.bodyGrey,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createButtonDone() {
    return Consumer<ConfessProvider>(
        builder: (context, confessProvider, child) {
          if (confessProvider.listConfess.isEmpty) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: GradientButton(
              increaseWidthBy: 90,
              increaseHeightBy: 7.0,
              elevation: 0,
              callback: () {
                confessProvider.confessDone();
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
    );
  }
}

class RelationItem extends StatelessWidget {
  const RelationItem(this.relation, this.position, this.size);

  final Map<String, List<ConfessionItem>> relation;
  final int position;
  final int size;

  Widget _buildTiles(Map<String, List<ConfessionItem>> root, int position,
      BuildContext context) {
    return createParenItem(root, position, context);
  }

  Widget createParenItem(Map<String, List<ConfessionItem>> root, int position,
      BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(bottom: 12, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(root.values.elementAt(0)[0].category,
                      style: Styles.titleGreyBold),
                  Text('Lần', style: Styles.titleGrey),
                ],
              ),
            )),
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                BeanItem(root.values.elementAt(index), index, root.length),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: root.length,
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

  List<ConfessionItem> bean;
  int position;
  int size;

  @override
  _BeanItem createState() => _BeanItem(bean, position, size);
}

class _BeanItem extends State<BeanItem> {
  _BeanItem(this.bean, this.position, this.size);

  List<ConfessionItem> bean;
  int position;
  int size;
  bool monVal = false;

  Widget _buildTiles(List<ConfessionItem> root, int position,
      BuildContext context) {
    return createChildItem(root, position, context);
  }

  Widget createChildItem(List<ConfessionItem> root, int position,
      BuildContext context) {
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
                        Padding(
                          padding: EdgeInsets.only(left: 9),
                          child: Text(
                            root[0].name,
                            style: Styles.bodyGrey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "x" + root.length.toString(),
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

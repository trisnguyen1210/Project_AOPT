import 'package:beans/generated/r.dart';
import 'package:beans/model/relational_reason.dart';
import 'package:beans/model/relational_subcategory_detail.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class RelationDetail extends StatelessWidget {
  final int categoryId;
  final String categoryTitle;
  final String subcateTitle;
  final RelationalSubcategoryDetail detail;

  const RelationDetail(
      {Key key,
      this.categoryId,
      this.detail,
      this.subcateTitle,
      this.categoryTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return false;
          },
          child:  Scaffold(
            backgroundColor: Colors.white,
            appBar: GradientAppBar(
              elevation: 0,
              brightness: Brightness.light,
              gradient: GradientApp.gradientAppbar,

              leading: IconButton(
                icon: Utils.getIconBack(),
                color:  Color(0xff88674d),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: false,
              titleSpacing: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 10, bottom: 20),
                    child: createTopViewRelation(),
                  ),
                  Opacity(
                    opacity: 0.2701590401785715,
                    child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xff979797), width: 1))),
                  ),
                  createListViewTopic(detail.reaons),
                  createBeanBottle(),
                  createButtonDone(context)
                ],
              ),
            ),
          )
      );

  }

  Widget createListViewTopic(List<RelationalReason> reasons) {
    var gratefulReasons = List<Bean>();
    var badReasons = List<Bean>();

    reasons.forEach((reason) {
      if (reason.isGrateful) {
        gratefulReasons.add(Bean(reason.name));
      } else {
        badReasons.add(Bean(reason.name));
      }
    });

    List<Topic> data = [
      Topic("Tôi biết ơn vì", gratefulReasons),
      Topic("Tôi trăn trở vì", badReasons),
    ];

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom:20, top:20),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TopicItem(data[index], index, data.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
      ),
    );
  }

  Widget createButtonDone(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 32),
            child: GradientButton(
              increaseWidthBy: 40,
              elevation: 0,
              increaseHeightBy: 7.0,
              callback: () {
                Utils.goToConfessSuccess(context);
              },
              gradient: GradientApp.gradientButton,
              child: Text("Xong", style: Styles.buttonText),
            ),
          ),
          GradientButton(
            increaseWidthBy: 40,
            increaseHeightBy: 7.0,
            elevation: 0,
            callback: () {
              Navigator.of(context).pop();
            },
            gradient: GradientApp.gradientButtonGrey,
            child: Text("Huỷ", style: Styles.buttonText),
          )
        ],
      ),
    );
  }

  Widget createBeanBottle() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [SvgPicture.asset(R.ic_white_bean, height: 73),
                    Positioned(
                        left: 13.0,
                        top:10,
                        child:  RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '+2',
                            style: Styles.boldWhite,
                          )
                        ],
                      ),
                    ))
                   ,]
                )

              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                  children: [SvgPicture.asset(R.ic_black_bean, height: 73),
                    Positioned(
                        right: 13.0,
                        top:10,
                        child:  RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '+2',
                                style: Styles.boldWhite,
                              )
                            ],
                          ),
                        ))
                  ]
              )

            ],
          ),
        ],
      ),
    );
  }

  Widget createTopViewRelation() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          // height: double.infinity,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: categoryTitle+ " | ",
                  style: Styles.headingBoldPurple,
                ),
                TextSpan(
                  text: subcateTitle,
                  style: Styles.textStyleRegular,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          // height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(detail.description, style: Styles.headingGrey),
          ),
        ),
      ],
    );
  }
}

class Topic {
  Topic(this.title, this.beans);

  final String title;
  List<Bean> beans;
}

class Bean {
  Bean(this.title);

  final String title;
}

class TopicItem extends StatelessWidget {
  const TopicItem(this.topic, this.position, this.size);

  final Topic topic;
  final int position;
  final int size;

  Widget _buildTiles(Topic root, int position, BuildContext context) {
    return createParenItem(root, position, context);
  }

  Widget createParenItem(Topic root, int position, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(root.title, style: Styles.titlePurple),
          ),
        ),
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
    return _buildTiles(topic, position, context);
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
    if (position == size - 1) {
      return createChildOtherItem(root, position, context);
    } else {
      return createChildItem(root, position, context);
    }
  }

  Widget createChildOtherItem(Bean root, int position, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 9),
                  child: SizedBox(
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
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(right: 48),
                        child: TextField(
                          cursorColor: Color(0xff88674d),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffcfcfcf))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff88674d))),
                              contentPadding: EdgeInsets.symmetric(vertical: 1),
                              //Change this value to custom as you like
                              isDense: true,
                              // and add this line
                              hintStyle: Styles.hintGrey,
                              hintText: 'Lí do khác…'),
                          style: Styles.bodyGrey,
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 9),
                        child: Text(
                          root.title,
                          style: Styles.bodyGrey,
                        ),
                      )
                    ),

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

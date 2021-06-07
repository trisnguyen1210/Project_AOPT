import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class RelationDetailOther extends StatelessWidget {

  final int categoryId;
  final String categoryTitle;
  final String subcateTitle;
  const RelationDetailOther(
      {Key key,
        this.categoryId,
        this.subcateTitle,
        this.categoryTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              margin: EdgeInsets.only(left: 20, right: 10, bottom: 5),
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
            createListViewTopic(),
            createBeanBottle(),
            createButtonDone(context)
          ],
        ),
      ),
    );
  }

  Widget createListViewTopic() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom:20),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TopicItem(dataOther[index], index, dataOther.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataOther.length,
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
              increaseHeightBy: 7.0,
              elevation: 0,
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
      ],
    );
  }
}

class Topic {
  Topic(this.title, [this.beans = const <Bean>[]]);

  final String title;
  final List<Bean> beans;
}

class Bean {
  Bean(this.title);

  final String title;
}

List<Topic> dataOther = <Topic>[
  Topic(
    'Tôi biết ơn vì',
    <Bean>[
      Bean('Lí do'),
      Bean('Lí do'),
    ],
  ),
  Topic(
    'Tôi trăn trở vì',
    <Bean>[
      Bean('Lí do'),
    ],
  ),
];

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
            padding: EdgeInsets.only(top: 25),
            child: Text(root.title, style: Styles.titlePurple),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                BeanItemOther(root.beans[index], index, root.beans.length),
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

class BeanItemOther extends StatelessWidget {
  const BeanItemOther(this.bean, this.position, this.size);

  final Bean bean;
  final int position;
  final int size;

  Widget createChildItem(Bean root, int position, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0, top: 5, right: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 15),
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              TextField(
                cursorColor: Color(0xff88674d),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffcfcfcf))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff88674d))),
                  hintStyle: Styles.hintGrey,
                  //Change this value to custom as you like
                  isDense: true,
                  hintText: 'Lí do',
                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SvgPicture.asset(R.ic_close, height: 15,  color: Color(0xff88674d))),
            ],
          ),
        ),
      ),
    );
  }

  Widget createChildAddItem(Bean root, int position, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0, top: 5, right: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 15),
          child: Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffcfcfcf))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff88674d))),
                  hintStyle: Styles.hintGrey,
                  //Change this value to custom as you like
                  isDense: true,
                  hintText: 'Thêm Lí do',
                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (position == 1)
      return createChildAddItem(bean, position, context);
    else
      return createChildItem(bean, position, context);
  }
}

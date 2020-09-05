import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class RelationDetailOther extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        gradient: GradientApp.gradientAppbar,
        leading: IconButton(
          icon: Utils.getIconBack(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        title: SvgPicture.asset(
          R.ic_snowman,
          width: 99,
          height: 43,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 5),
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
            createButtonDone()
          ],
        ),
      ),
    );
  }

  Widget createListViewTopic() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TopicItem(dataOther[index], index, dataOther.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataOther.length,
      ),
    );
  }

  Widget createButtonDone() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: GradientButton(
        increaseWidthBy: 90,
        increaseHeightBy: 7.0,
        callback: () {},
        gradient: GradientApp.gradientButton,
        child: Text("Xét mình xong", style: Styles.buttonText),
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
            padding: EdgeInsets.only(right: 42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Biết ơn ',
                          style: Styles.titlePurple,
                        ),
                        TextSpan(
                          text: '+2',
                          style: Styles.titleGrey,
                        )
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(R.ic_white_bean, height: 79)
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Trăn trở ',
                        style: Styles.titlePurple,
                      ),
                      TextSpan(
                        text: '+2',
                        style: Styles.titleGrey,
                      )
                    ],
                  ),
                ),
              ),
              SvgPicture.asset(R.ic_black_bean, height: 79)
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
                  text: 'Tôi ',
                  style: Styles.headingPurple,
                ),
                WidgetSpan(
                  child: SvgPicture.asset(R.ic_more, height: 24),
                ),
                TextSpan(
                  text: 'Khác',
                  style: Styles.textStyleRelation,
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
                cursorColor: Color(0xff9b3790),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff9b3790))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffcfcfcf))),
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
                  child: SvgPicture.asset(R.ic_close, height: 15)),
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
                      borderSide: BorderSide(color: Color(0xff9b3790))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffcfcfcf))),
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

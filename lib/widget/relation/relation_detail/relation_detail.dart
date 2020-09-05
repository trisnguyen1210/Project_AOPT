import 'package:beans/generated/r.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class RelationDetail extends StatelessWidget {
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
        title: Container(
          child: SvgPicture.asset(
            R.ic_snowman,
            width: 99,
            height: 43,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
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
      padding: EdgeInsets.all(20),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TopicItem(data[index], index, data.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
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
                  child: SvgPicture.asset(R.ic_health, height: 24),
                ),
                TextSpan(
                  text: 'Khả năng & Sức khoẻ',
                  style: Styles.textStyleRelation,
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
            child: Text('Đối với sức khoẻ của tôi hôm nay',
                style: Styles.headingGrey),
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

List<Topic> data = <Topic>[
  Topic(
    'Tôi biết ơn vì',
    <Bean>[
      Bean('Tôi được khoẻ mạnh'),
      Bean('Tôi ít đau bệnh'),
      Bean('Lí do khác…'),
    ],
  ),
  Topic(
    'Tôi trăn trở vì',
    <Bean>[
      Bean('Tôi không bảo vệ sức khoẻ'),
      Bean('Tôi vui chơi quá độ'),
      Bean('Lí do khác…'),
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
                          cursorColor: Color(0xff9b3790),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(
                                      0xff9b3790))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(
                                      0xffcfcfcf))),
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
                    Padding(
                      padding: EdgeInsets.only(left: 9),
                      child: Text(
                        root.title,
                        style: Styles.bodyGrey,
                      ),
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

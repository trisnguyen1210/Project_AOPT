import 'package:beans/generated/r.dart';
import 'package:beans/provider/relation_detail_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class RelationDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: GradientAppBar(
          elevation: 0,
          brightness: Brightness.light,
          gradient: GradientApp.gradientAppbar,
          leading: IconButton(
            icon: Utils.getIconBack(),
            color: Color(0xff88674d),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: false,
          titleSpacing: 0.0,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                createTopViewRelation(context),
                divider(),
                createListViewTopic(context),
                createBeanBottle(context),
                createButtonDone(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createTopViewRelation(BuildContext context) {
    final relationDetailProvider = Provider.of<RelationDetailProvider>(
      context,
      listen: false,
    );
    final categoryTitle = relationDetailProvider.categoryTitle;
    final subcateTitle = relationDetailProvider.subcateTitle;
    final description = relationDetailProvider.description;

    return Container(
      margin: EdgeInsets.only(left: 20, right: 10, bottom: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: categoryTitle + " | ",
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
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(description, style: Styles.headingGrey),
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Opacity(
      opacity: 0.2701590401785715,
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff979797), width: 1),
        ),
      ),
    );
  }

  Widget createListViewTopic(BuildContext context) {
    final relationDetailProvider = Provider.of<RelationDetailProvider>(context);

    final data = relationDetailProvider.topics;

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TopicItem(data[index], index, data.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
      ),
    );
  }

  Widget createBeanBottle(BuildContext context) {
    final provider = Provider.of<RelationDetailProvider>(context);

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
                Stack(children: [
                  SvgPicture.asset(R.ic_white_bean, height: 73),
                  Positioned(
                    left: 13.0,
                    top: 10,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: provider.grateFulCount,
                            style: Styles.boldWhite,
                          )
                        ],
                      ),
                    ),
                  ),
                ])
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                SvgPicture.asset(R.ic_black_bean, height: 73),
                Positioned(
                  right: 13.0,
                  top: 10,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: provider.ungrateFulCount,
                          style: Styles.boldWhite,
                        )
                      ],
                    ),
                  ),
                )
              ])
            ],
          ),
        ],
      ),
    );
  }

  void _submitRelation(BuildContext context) async {
    final provider =
        Provider.of<RelationDetailProvider>(context, listen: false);

    BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Đang tải"),
              ],
            ),
          ),
        );
      },
    );

    await provider.submitRelation();
    Navigator.pop(dialogContext);
    Utils.goToConfessSuccess(context);
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
                _submitRelation(context);
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
}

class TopicItem extends StatelessWidget {
  const TopicItem(this.topic, this.position, this.size);

  final Topic topic;
  final int position;
  final int size;

  @override
  Widget build(BuildContext context) {
    return _buildTiles(topic, position, context);
  }

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
    final provider = Provider.of<RelationDetailProvider>(
      context,
      listen: false,
    );

    final titleDidChange = (String title) {
      setState(() {
        final isChecked = title.isNotEmpty;
        monVal = isChecked;
      });
      provider.updateOtherReason(
        title,
        monVal,
        root.isGrateful,
      );
    };

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
                      onChanged: null,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 48),
                    child: TextField(
                      onChanged: titleDidChange,
                      cursorColor: Color(0xff88674d),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffcfcfcf)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff88674d)),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                        isDense: true,
                        hintStyle: Styles.hintGrey,
                        hintText: 'Lí do khác…',
                      ),
                      style: Styles.bodyGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget createChildItem(Bean root, int position, BuildContext context) {
    final provider = Provider.of<RelationDetailProvider>(
      context,
      listen: false,
    );

    return InkWell(
        onTap: () {
          setState(() {
            monVal = !monVal;
            provider.addOrRemoveTheReason(
              position,
              monVal,
              root.isGrateful,
            );
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
                            monVal = value;
                            provider.addOrRemoveTheReason(
                              position,
                              value,
                              root.isGrateful,
                            );
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
                    )),
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

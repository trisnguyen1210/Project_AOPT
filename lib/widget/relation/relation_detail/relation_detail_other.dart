import 'package:beans/generated/r.dart';
import 'package:beans/provider/relation_detail_other_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class RelationDetailOther extends StatelessWidget {
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
          color: Color(0xff88674d),
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
              child: createTopViewRelation(context),
            ),
            Opacity(
              opacity: 0.2701590401785715,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff979797), width: 1),
                ),
              ),
            ),
            createListViewTopic(context),
            createBeanBottle(context),
            createButtonDone(context)
          ],
        ),
      ),
    );
  }

  Widget createListViewTopic(BuildContext context) {
    final provider = Provider.of<RelationDetailOtherProvider>(context);
    final data = provider.topics;
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            TopicItem(data[index], index, data.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
      ),
    );
  }

  void _submitRelation(BuildContext context) async {
    final provider =
        Provider.of<RelationDetailOtherProvider>(context, listen: false);

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
              increaseHeightBy: 7.0,
              elevation: 0,
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

  Widget createBeanBottle(BuildContext context) {
    final provider = Provider.of<RelationDetailOtherProvider>(context);

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
                      )),
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
                    ))
              ])
            ],
          ),
        ],
      ),
    );
  }

  Widget createTopViewRelation(BuildContext context) {
    final provider =
        Provider.of<RelationDetailOtherProvider>(context, listen: false);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: provider.categoryTitle + " | ",
                  style: Styles.headingBoldPurple,
                ),
                TextSpan(
                  text: provider.subcateTitle,
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
  BeanItemOther(this.bean, this.position, this.size);

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
                onChanged: (title) {
                  final provider = Provider.of<RelationDetailOtherProvider>(
                      context,
                      listen: false);
                  provider.updateBean(title, position, bean.isGrateful);
                },
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
                  child: SvgPicture.asset(R.ic_close,
                      height: 15, color: Color(0xff88674d))),
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
    return createChildItem(bean, position, context);
  }
}

import 'package:beans/generated/r.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:beans/utils/utils.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/about/setting_screen.dart';
import 'package:beans/widget/custom/expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AboutBeans extends StatelessWidget {
  const AboutBeans({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<AuthProvider>(context, listen: false).name;

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
            title: Text("Chào ${userName}!", style: Styles.headingBoldPurple)),
        body: createListViewAbout(context),
      ),
    );
  }
}

Widget createListViewAbout(BuildContext context) {
  List<About> data = [];
  List<AboutDes> listDes = [];
  listDes.add(new AboutDes(
      "Beans app là một ứng dụng di động dành cho người công giáo, người kitô hữu và những ai mong muốn hiểu và hoà giải với chính mình, với mọi người xung quanh và với Thiên Chúa.\n\nBeans app có gì đặc biệt?\n\n1. Vào cuối ngày, bạn có thể ghi nhận những điều khiến mình hạnh phúc hay trăn trở như viết nhật kí nhưng chỉ tốn 2-5 phút.\n\n2. Những điều khiến bạn trăn trở mỗi ngày sẽ được ghi nhận lại thành một danh sách tiện dụng (bản xét mình) để bạn dễ dàng xưng tội.\n\n3. Beans app sẽ giữ thông tin của bạn hoà toàn bí mật và bạn có thể xoá bất cứ lúc nào.\n\n4. Với THỬ THÁCH 24H, bạn có thể thử thách bản thân làm những việc tốt đẹp ngẫu nhiên cho mình hoặc cho người khác.\n\nBeans app giúp người dùng chuyển đổi những việc tốt hoặc việc chưa tốt thành những hạt đậu số. Với những hạt đậu này, bạn có thể tạo cho riêng mình một khu vườn bí mật, một nơi để sống nội tâm hơn."));
  data.add(About("Giới thiệu về Beans", listDes, true, R.ic_down_arrow));
  data.add(About(
      "Chia sẻ Beans với người thân", new List<AboutDes>(), false, R.ic_share));
  data.add(About(
      "Liên hệ Beans/ Cần hỗ trợ", new List<AboutDes>(), false, R.ic_contact));
  data.add(
      About("Cài đặt & Bảo mật", new List<AboutDes>(), false, R.ic_settings));
  data.add(About("Tặng cho Beans 1 ly trà sữa", new List<AboutDes>(), false,
      R.ic_milkshake));

  return Padding(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            AboutItem(data[index], index, data.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
      ));
}

class About {
  About(this.title, this.aboutDes, this.isExpand, this.icon);

  String title;
  List<AboutDes> aboutDes = [];
  bool isExpand;
  String icon;
}

class AboutDes {
  AboutDes(this.description);

  String description;
}

class AboutItem extends StatelessWidget {
  const AboutItem(this.about, this.position, this.size);

  final About about;
  final int position;
  final int size;

  Widget createParentNoChild(About root, int position, BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (about.title == "Cài đặt & Bảo mật") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingScreen(),
              ),
            );
          }
        },
        child: ListTile(
          trailing: SvgPicture.asset(root.icon, color: Color(0xff88674d)),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${root.title}',
                  style: Styles.headingGrey,
                  textAlign: TextAlign.start,
                ),
              ]),
        ));
  }

  Widget _buildTiles(About root, int position, BuildContext context) {
    if (root.isExpand) {
      return createParenItem(root, position, context);
    } else {
      return createParentNoChild(root, position, context);
    }
  }

  Widget createParenItem(About root, int position, BuildContext context) {
    return CustomExpansionTile(
      key: PageStorageKey<About>(root),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${root.title}',
              style: Styles.headingGrey,
              textAlign: TextAlign.start,
            ),
          ]),
      children: mapIndexed(root.aboutDes,
          (index, item) => createChildItem(item, index + 1, context)).toList(),
      headerBackgroundColor: Colors.white,
      trailing: SvgPicture.asset(root.icon, color: Color(0xff88674d)),
    );
  }

  Widget createChildItem(AboutDes root, int position, BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ListTile(title: Text(root.description, style: Styles.titleGrey)),
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(about, position, context);
  }
}

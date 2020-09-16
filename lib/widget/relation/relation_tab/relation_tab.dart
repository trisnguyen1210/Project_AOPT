import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/custom/expansion_tile.dart';
import 'package:beans/widget/relation/relation_detail/relation_detail.dart';
import 'package:beans/widget/relation/relation_detail/relation_detail_other.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RelationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            createTopTitle(),
            createListViewCategory(),
          ],
        ),
      ),
    );
  }
}

Widget createListViewCategory() {
  return ListView.builder(
    itemBuilder: (BuildContext context, int index) =>
        EntryItem(data[index], index, data.length),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: data.length,
  );
}

Widget createTopTitle() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
    child: RichText(
      text: TextSpan(
        style: Styles.bodyGrey,
        children: [
          TextSpan(
              text:
                  'Bạn hãy chọn 1 điều làm mình trăn trở hay hạnh phúc nhất hôm nay để ghi nhận lại.  '),
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

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, this.icon, [this.children = const <Entry>[]]);

  final String title;
  final String icon;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
List<Entry> data = <Entry>[
  Entry(
    'Khả năng & Sức khoẻ',
    R.ic_health,
    <Entry>[
      Entry('Khả năng & Sức khoẻ', ""),
      Entry('Khả năng & Sức khoẻ', ""),
      Entry('Khả năng & Sức khoẻ', ""),
    ],
  ),
  Entry(
    'Của cải & Vật chất',
    R.ic_money,
    <Entry>[
      Entry('Của cải & Vật chất', ""),
      Entry('Của cải & Vật chất', ""),
    ],
  ),
  Entry(
    'Đặc quyền & Sự yếu đuối',
    R.ic_human_rights,
    <Entry>[
      Entry('Đặc quyền & Sự yếu đuối', ""),
      Entry('Đặc quyền & Sự yếu đuối', ""),
      Entry('Đặc quyền & Sự yếu đuối', ""),
    ],
  ),
  Entry(
    'Thời gian & Hoàn cảnh',
    R.ic_time,
    <Entry>[
      Entry('Thời gian & Hoàn cảnh', ""),
      Entry('Thời gian & Hoàn cảnh', ""),
      Entry('Thời gian & Hoàn cảnh', R.ic_time),
    ],
  ),
  Entry(
    'Khác',
    R.ic_more,
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.position, this.size);

  final Entry entry;
  final int position;
  final int size;

  Widget createChildItem(Entry root, int position, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RelationDetail()),
        );
      },
      child: ListTile(
          title: Text(position.toString() + ". " + root.title,
              style: Styles.bodyGrey)),
    );
  }

  Widget createParentNoChild(Entry root, int position, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RelationDetailOther()),
        );
      },
      child: ListTile(
          title: Text(root.title, style: Styles.headingGrey),
          leading: SvgPicture.asset(root.icon, height: 40, width: 53)),
    );
  }

  Widget _buildTiles(Entry root, int position, BuildContext context) {
    if (root.children.isEmpty) {
      if (position == size - 1) {
        //createParentNoChild(root, position, context);
        return createParentNoChild(root, position, context);
      } else {
        return createChildItem(root, position, context);
      }
    } else {
      return createParenItem(root, position, context);
    }
  }

  Widget createParenItem(Entry root, int position, BuildContext context) {
    return CustomExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: Styles.headingGrey,
      ),
      children: mapIndexed(root.children,
          (index, item) => _buildTiles(item, index + 1, context)).toList(),
      leading: SvgPicture.asset(root.icon, height: 40, width: 53),
      headerBackgroundColor: Colors.white,
      iconColor: Color(0xff316beb),
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
    return _buildTiles(entry, position, context);
  }
}

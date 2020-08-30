import 'package:beans/generated/r.dart';
import 'package:beans/value/styles.dart';
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 20),
              child: RichText(
                text: TextSpan(
                  style: Styles.textStyleGreyNormal,
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
            ),
            ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  EntryItem(data[index], index),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
            ),
          ],
        ),
      ),
    );
  }
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
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.position);

  final Entry entry;
  final int position;

  Widget _buildTiles(Entry root, int position) {
    if (root.children.isEmpty)
      return ListTile(
          title: Text(position.toString() + "." + root.title,
              style: Styles.textStyleGreyNormal),
          trailing: SvgPicture.asset(R.ic_arrow_next, height: 15));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: Styles.textStyleGreyMedium,
      ),
      children: mapIndexed(
              root.children, (index, item) => _buildTiles(item, index + 1))
          .toList(),
      leading: SvgPicture.asset(root.icon, height: 40, width: 53),
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
    return _buildTiles(entry, position);
  }
}

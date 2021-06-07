import 'package:beans/dao/relational_category_dao.dart';
import 'package:beans/dao/relational_item_dao.dart';
import 'package:beans/model/confession.dart';

class ConsfessionUsecase {
  final _categoryDao = RelationalCategoryDao();
  final _itemDao = RelationalItemDao();

  Future<Map<String, Map<String, List<ConfessionItem>>>>
      getListConfession() async {
    var categories = await _categoryDao.getList();
    var items = await _itemDao.getListRelationalItem();

    var list = items.map((item) {
      final categoryName = categories
          .firstWhere((cat) => cat.id == item.relationalCategoryId)
          .name;
      return ConfessionItem(
          item.id, item.name, categoryName, item.createdAt, item.createdAt);
    }).groupBy(
      (p) => p.category,
    );

    var finalList = new Map<String, Map<String, List<ConfessionItem>>>();
    list.forEach((index, value) {
      var v = value.groupBy(
        (p) => p.name,
      );
      finalList[index] = v;
    });

    return finalList;
  }

  Future<int> confessDone() async {
    return await _itemDao.deleteAll();
  }

  // ngày bắt đầu bản xưng tôi
  Future<DateTime> getDateFrom() async {
    var item = await _itemDao.getFirst();
    return item?.createdAt ?? DateTime.now();
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

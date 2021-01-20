import 'package:beans/dao/relational_item_dao.dart';
import 'package:beans/model/relational_item.dart';

class RelationUseCase {
  final _relationalItemDao = RelationalItemDao();

  Future<int> createBean(RelationalItem relationalItem) async {
    return await _relationalItemDao.createBean(relationalItem);
  }

  Future<List<RelationalItem>> getListRelationalItem() async {}
}

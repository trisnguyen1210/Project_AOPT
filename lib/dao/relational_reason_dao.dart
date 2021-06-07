import 'package:beans/database/database_provider.dart';
import 'package:beans/model/relational_reason.dart';

class RelationalReasonDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> create(RelationalReason reason) async {
    final db = await dbProvider.database;
    return db.insert(relationalReasonsTable, reason.toMap());
  }

  Future<List<RelationalReason>> getByDetailID(int detailID,
      {bool isOther = false}) async {
    final db = await dbProvider.database;
    final _isOther = isOther ? 1 : 0;
    List<Map<String, dynamic>> result;
    if (detailID != null) {
      result = await db.query(
        relationalReasonsTable,
        where: '''
        relational_subcategory_detail_id = ? AND
        is_other = ?
        ''',
        whereArgs: [detailID, _isOther],
      );
    } else {
      result = await db.query(relationalReasonsTable);
    }

    List<RelationalReason> reasons = result.isNotEmpty
        ? result.map((item) => RelationalReason.fromMap(item)).toList()
        : [];

    return reasons;
  }
}

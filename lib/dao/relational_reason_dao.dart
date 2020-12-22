import 'package:beans/database/database_provider.dart';
import 'package:beans/model/relational_reason.dart';

class RelationalReasonDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<RelationalReason>> getByDetailID(int detailID) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (detailID != null) {
      result = await db.query(
        relationalReasonsTable,
        where: 'relational_subcategory_detail_id = ?',
        whereArgs: [detailID],
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

import 'package:beans/database/database_provider.dart';
import 'package:beans/model/relational_subcategory_detail.dart';

class RelationalSubcategoryDetailDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<RelationalSubcategoryDetail>> getListBySubcategoryId(
      int subcategoryId) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (subcategoryId != null) {
      result = await db.query(
        relationalSubcategoryDetailsTable,
        where: 'relational_subcategory_id = ?',
        whereArgs: [subcategoryId],
      );
    } else {
      result = await db.query(relationalSubcategoryDetailsTable);
    }

    List<RelationalSubcategoryDetail> subcategoryDetails = result.isNotEmpty
        ? result
            .map((item) => RelationalSubcategoryDetail.fromMap(item))
            .toList()
        : [];
    return subcategoryDetails;
  }
}

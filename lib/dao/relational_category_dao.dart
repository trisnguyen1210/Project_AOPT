import 'package:beans/database/database_provider.dart';
import 'package:beans/model/relational_category.dart';

class RelationalCategoryDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<RelationalCategory>> getList(
      {List<String> columns, String query}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (query != null && query.isNotEmpty) {
      result = await db.query(
        relationalCategoriesTable,
        columns: columns,
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
      );
    } else {
      result = await db.query(relationalCategoriesTable, columns: columns);
    }

    List<RelationalCategory> relationalCategories = result.isNotEmpty
        ? result.map((item) => RelationalCategory.fromMap(item)).toList()
        : [];

    return relationalCategories;
  }
}

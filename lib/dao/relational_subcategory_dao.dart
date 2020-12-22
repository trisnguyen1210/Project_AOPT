import 'package:beans/database/database_provider.dart';
import 'package:beans/model/relational_subcategory.dart';

class RelationalSubcategoryDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<RelationalSubcategory>> getListByCategoryId(
      int categoryId) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (categoryId != null) {
      result = await db.query(
        relationalSubcategoriesTable,
        where: 'relational_category_id = ?',
        whereArgs: [categoryId],
      );
    } else {
      result = await db.query(relationalSubcategoriesTable);
    }

    List<RelationalSubcategory> subcategories = result.isNotEmpty
        ? result.map((item) => RelationalSubcategory.fromMap(item)).toList()
        : [];
    return subcategories;
  }
}

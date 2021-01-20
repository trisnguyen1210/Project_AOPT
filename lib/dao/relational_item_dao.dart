import 'package:beans/database/database_provider.dart';
import 'package:beans/model/relational_item.dart';

class RelationalItemDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createBean(RelationalItem relationalItem) async {
    final db = await dbProvider.database;
    return db.insert(usersTable, relationalItem.toMap());
  }

  Future<List<RelationalItem>> getListRelationalItem() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.query(
      relationalItemsTable,
      where: 'is_Confess = ?',
      whereArgs: [0],
    );
    List<RelationalItem> relationalItems = result.isNotEmpty
        ? result.map((item) => RelationalItem.fromMap(item)).toList()
        : [];

    return relationalItems;
  }
}

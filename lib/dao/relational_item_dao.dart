import 'package:beans/database/database_provider.dart';
import 'package:beans/model/relational_item.dart';
import 'package:sqflite/sqlite_api.dart';

class RelationalItemDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createBean(RelationalItem relationalItem) async {
    final db = await dbProvider.database;
    return db.insert(usersTable, relationalItem.toMap());
  }

  createBeans(List<RelationalItem> items) async {
    final db = await dbProvider.database;
    Batch batch = db.batch();
    items.forEach((bean) {
      batch.insert(relationalItemsTable, bean.toMap());
    });
    await batch.commit(noResult: true);
  }

  Future<RelationalItem> getFirst() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.query(relationalItemsTable, limit: 1);
    if (result.isEmpty) {
      return null;
    }
    return RelationalItem.fromMap(result.first);
  }

  Future<List<RelationalItem>> getListRelationalItem() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.query(relationalItemsTable);
    List<RelationalItem> relationalItems = result.isNotEmpty
        ? result.map((item) => RelationalItem.fromMap(item)).toList()
        : [];

    return relationalItems;
  }

  Future<int> deleteAll() async {
    final db = await dbProvider.database;
    return await db.delete(relationalItemsTable);
  }
}

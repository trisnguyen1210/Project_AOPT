import 'package:beans/database/database_provider.dart';
import 'package:beans/model/target.dart';

class TargetDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<Target> get() async {
    final db = await dbProvider.database;

    final result = await db.query(
      targetsTable,
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Target.fromMap(result.first);
  }

  Future<int> create(Target target) async {
    final db = await dbProvider.database;
    return db.insert(targetsTable, target.toMap());
  }

  Future<Target> getOrCreate() async {
    final db = await dbProvider.database;

    final result = await db.query(
      targetsTable,
      limit: 1,
    );

    if (result.isEmpty) {
      var initTarget = Target(id: 1, greenCount: 30, blackCount: 30);
      await create(initTarget);
      return initTarget;
    }

    return Target.fromMap(result.first);
  }

  Future<int> update(Target target) async {
    final db = await dbProvider.database;

    return await db.update(
      targetsTable,
      target.toMap(),
      where: 'id = ?',
      whereArgs: [target.id],
    );
  }
}

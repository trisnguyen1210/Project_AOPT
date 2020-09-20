import 'package:beans/database/database_provider.dart';
import 'package:beans/model/user.dart';

class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<User> get() async {
    final db = await dbProvider.database;

    final result = await db.query(
      usersTable,
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(result.first);
  }

  Future<int> create(User user) async {
    final db = await dbProvider.database;
    return db.insert(usersTable, user.toMap());
  }

  Future<User> getOrCreate() async {
    final db = await dbProvider.database;

    final result = await db.query(
      usersTable,
      limit: 1,
    );

    if (result.isEmpty) {
      final initUser = User(name: 'username');
      create(initUser);
      return initUser;
    }

    return User.fromMap(result.first);
  }

  Future<int> update(User user) async {
    final db = await dbProvider.database;

    return await db.update(
      usersTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final badgesTable = 'badges';
final challengesTable = 'challenges';
final challengeLogsTable = 'challenge_logs';
final godWordsTable = 'god_words';
final scheduleTypesTable = 'schedule_types';
final schedulesTable = 'schedules';
final targetsTable = 'targets';
final relationalCategoriesTable = 'relational_categories';
final relationalSubcategoriesTable = 'relational_subcategories';
final relationalSubcategoryDetailsTable = 'relational_subcategory_details';
final relationalCategorySubcategoriesTable =
    'relational_category_subcategories';
final relationalItemsTable = 'relational_items';
final relationalReasonsTable = 'relational_reasons';
final relationalItemReasonsTable = 'relational_item_reasons';
final usersTable = 'users';

class DatabaseProvider {
  static final dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    final pathDB = join(await getDatabasesPath(), 'beans.db');
    print(pathDB);
    return openDatabase(
      pathDB,
      onCreate: initDB,
      onUpgrade: onUpgrade,
      version: 1,
    );
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    final sqls = [
      createTableBadges(),
      createTableChallenges(),
      createTableChallengeLogs(),
      createTableGodWords(),
      createTableScheduleTypes(),
      createTableSchedules(),
      createTableRelationalCategories(),
      createTableRelationalSubcategories(),
      createTableRelationalSubcategoryDetails(),
      createTableRelationalCategorySubcategories(),
      createTableRelationalItems(),
      createTableRelationalReasons(),
      createTableRelationalItemReasons(),
      createTableTargets(),
      createTableUsers(),
      seedChallenges(),
    ];

    final batch = database.batch();

    for (var sql in sqls) {
      batch.execute(sql);
    }

    await batch.commit();
  }

  String createTableBadges() {
    return '''
        CREATE TABLE $badgesTable (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        description TEXT, 
        received_at TEXT 
        );
        ''';
  }

  String createTableChallenges() {
    return '''
      CREATE TABLE $challengesTable (
        id INTEGER PRIMARY KEY, 
        name TEXT 
        );
        ''';
  }

  String createTableChallengeLogs() {
    return '''
      CREATE TABLE $challengeLogsTable (
        id INTEGER PRIMARY KEY, 
        challenge_id INTEGER, 
        is_done INTEGER, 
        created_at TEXT, 
        due_at TEXT 
        );
    ''';
  }

  String createTableGodWords() {
    return '''
        CREATE TABLE $godWordsTable (
        id INTEGER PRIMARY KEY, 
        word TEXT 
        );
    ''';
  }

  String createTableSchedules() {
    return '''
        CREATE TABLE $schedulesTable (
        id INTEGER PRIMARY KEY, 
        schedule_type_id INTEGER,
        description TEXT, 
        location TEXT, 
        time TEXT 
        );
    ''';
  }

  String createTableScheduleTypes() {
    return '''
        CREATE TABLE $scheduleTypesTable (
        id INTEGER PRIMARY KEY, 
        name TEXT 
        );
    ''';
  }

  String createTableRelationalCategories() {
    return '''
        CREATE TABLE $relationalCategoriesTable (
        id INTEGER PRIMARY KEY, 
        name TEXT,
        icon TEXT 
        );
    ''';
  }

  String createTableRelationalSubcategories() {
    return '''
        CREATE TABLE $relationalSubcategoriesTable (
        id INTEGER PRIMARY KEY, 
        name TEXT,
        icon TEXT 
        );
    ''';
  }

  String createTableRelationalSubcategoryDetails() {
    return '''
        CREATE TABLE $relationalSubcategoryDetailsTable (
        id INTEGER PRIMARY KEY, 
        relational_subcategory_id INTEGER,
        description TEXT
        );
    ''';
  }

  String createTableRelationalCategorySubcategories() {
    return '''
        CREATE TABLE $relationalCategorySubcategoriesTable (
        id INTEGER PRIMARY KEY, 
        relational_category_id INTEGER,
        relational_subcategory_id INTEGER
        );
    ''';
  }

  String createTableRelationalItems() {
    return '''
        CREATE TABLE $relationalItemsTable (
        id INTEGER PRIMARY KEY, 
        created_at TEXT 
        );
        ''';
  }

  String createTableRelationalReasons() {
    return '''
 CREATE TABLE $relationalReasonsTable (
        id INTEGER PRIMARY KEY, 
        relational_category_id INTEGER, 
        relational_subcategory_id INTEGER, 
        is_grateful INTEGER, 
        is_other INTEGER, 
        name TEXT
        );
    ''';
  }

  String createTableRelationalItemReasons() {
    return '''
     CREATE TABLE $relationalItemReasonsTable (
        id INTEGER PRIMARY KEY, 
        relational_reason_id INTEGER, 
        relational_item_id INTEGER 
        );
    ''';
  }

  String createTableTargets() {
    return '''
        CREATE TABLE $targetsTable (
        id INTEGER PRIMARY KEY, 
        green_count INTEGER, 
        black_count INTEGER, 
        due_at TEXT
        );
    ''';
  }

  String createTableUsers() {
    return '''
        CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY, 
        current_challenge_log_id INTEGER, 
        name TEXT,
        pin TEXT,
        age_range TEXT,
        green_count INTEGER,
        black_count INTEGER,
        time_left_for_challenge TEXT 
        );
    ''';
  }

  String seedChallenges() {
    return '''
    INSERT INTO $challengesTable (name)
    VALUES
    ("Mời 1 người kém may mắn 1 bữa ăn "),
    ("Mời 1 nguòi kém may mắn 1 ly nuóc"),
    ("Tặng 1 người kém may mắn hơn 1 chiếc áo đẹp "),
    ("Nói 1 lời cảm ơn tới người giúp đỡ bạn"),
    ("Nói 1 lời xin lỗi tới người thân yêu mà bạn xúc phạm "),
    ("Đề nghị giúp đỡ 1 ai đó (dù là việc nhỏ)"),
    ("Thăm viếng người cô đơn, bệnh tật "),
    ("Gởi 1 món quà nhỏ tới người làm ơn cho bạn "),
    ("Cười và cám ơn người phục vụ đồ ăn cho bạn (tìm tên của họ để gọi nhé)"),
    ("dành thời gian hướng dẫn ai đó yếu hơn với sự kiên nhẫn và nụ cười "),
    ("Trao tặng 1 lời khen tới người nào đó với sự trân thành"),
    ("Tình nguyện làm 1 viêc tốt cho xã hội (nhặt 1 cọng rác, hiến máu nhân đạo)"),
    ("Tình nguyện giúp đỡ 1 người bạn gặp trên đường "),
    ("Nói lời tha thứ"),
    ("An ủi 1 người đang buồn mà bạn biết , tặng người ấy 1 món quà bất ngờ nhỏ "),
    ("Gởi 1 tấm thiệp cảm ơn tới 1 người bạn nhỏ bé, yếu đuối "),
    ("Làm 1 món ăn ngon cho cha mẹ hoặc người họ hàng gần với tất cả tình thuơng "),
    ("Dâng 1 lời nguyện/ đọc 3 kinh kính mừng cho người bạn không thích "),
    ("Viết ra 3 điều tốt đẹp của người làm bạn khó chịu hôm nay "),
    ("Gởi 1 món quà nhỏ tới người bạn ghét"),
    ("Hãy làm lành với người mà bạn đang oán hờn "),
    ("Cầu nguyện cho người mình không thich"),
    ("Lắng nghe quan điểm của người khác ");
    ''';
  }
}

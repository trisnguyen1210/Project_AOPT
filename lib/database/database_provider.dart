import 'dart:async';

import 'package:beans/generated/r.dart';
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
      createTableRelationalItems(),
      createTableRelationalReasons(),
      createTableRelationalItemReasons(),
      createTableTargets(),
      createTableUsers(),
      seedChallenges(),
      seedCategories(),
      seedSubcategories(),
      seedSubcategoryDetails(),
      seedReasons(),
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
        relational_category_id INTEGER,
        name TEXT,
        description TEXT 
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

  String createTableRelationalItems() {
    return '''
        CREATE TABLE $relationalItemsTable (
        id INTEGER PRIMARY KEY, 
        created_at TEXT ,
        relational_category_id INTEGER,
        relational_subcategory_id INTEGER,
        relational_subcategory_detail_id INTEGER, 
        is_grateful INTEGER, 
        is_other INTEGER DEFAULT 0, 
        name TEXT,
        is_Confess INTEGER DEFAULT 0);
        ''';
  }

  String createTableRelationalReasons() {
    return '''
 CREATE TABLE $relationalReasonsTable (
        id INTEGER PRIMARY KEY, 
        relational_category_id INTEGER,
        relational_subcategory_id INTEGER,
        relational_subcategory_detail_id INTEGER, 
        is_grateful INTEGER, 
        is_other INTEGER DEFAULT 0, 
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
        bod TEXT,
        green_count INTEGER,
        black_count INTEGER,
        time_left_for_challenge TEXT,
        email TEXT
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

  String seedCategories() {
    return '''
    INSERT INTO $relationalCategoriesTable (id, name, icon)
    VALUES
    (1, "Yêu Mình", "${R.ic_myself}"),
    (2, "Yêu Người", "${R.ic_other_guys}"),
    (3, "Yêu Chúa", "${R.ic_god}");
    ''';
  }

  String seedSubcategories() {
    return '''
    INSERT INTO $relationalSubcategoriesTable (id, relational_category_id, name, description)
    VALUES
    (1, 1, "Sức khoẻ và mạng sống", "- Điều răn 5 -"),
    (2, 1, "Cam kết yêu thương (Khiết tịnh và đam mê)","- Điều răn 6 & 9 -"),
    (3, 1, "Công bằng và của cải", "- Điều răn 7 & 10 -"),
    (4, 1, "Sự Thật và Danh Dự", "- Điều răn 8 -"),
    
    (5, 2, "Yêu tổ tiên, ông bà, cha mẹ và đất nước","- Điều răn 4 -"),
    (6, 2, "Mạng sống và phẩm giá", "- Điều răn 5 -"),
    (7, 2, "Khiết tịnh và hôn nhân","- Điều răn 6 & 9 -"),
    (8, 2, "Công bằng và của cải", "- Điều răn 7 & 10 -"),
    (9, 2, "Sự Thật và Danh Dự", "- Điều răn 8 -"),
    
    (10, 3, "Thờ phượng Chúa", "- Điều răn 1 -"),
    (11, 3, "Tôn kính Danh Chúa ","- Điều răn 2 -"),
    (12, 3, "Thánh hóa ngày của Chúa", "- Điều răn 3 -");
    ''';
  }

  String seedSubcategoryDetails() {
    return '''
    INSERT INTO $relationalSubcategoryDetailsTable (id, relational_subcategory_id, description)
    VALUES
    (1, 1, "Gìn giữ và chăm sóc sức khỏe của mình"),
    (2, 1, "Bảo vệ và phát triển sự sống của mình"),

    (5, 2, "Khiết tịnh"),

    (8, 3, "Công bằng với chính mình"),
    (9, 3, "Tôn trọng và phát triển của cải tôi đang có."),
    
    (11, 4, "Trung thực với chính mình"),
    (12, 4, "Bảo vệ danh dự của mình"),

    (16, 5, "Yêu ông bà và cha mẹ"),
    (17, 5, "Yêu con cái và cháu chắt"),
    (18, 5, "Yêu đất nước & dân tộc"),
  
    (31, 6, "Tôn trọng sự sống của người khác"),
    (32, 6, "Tôn trọng phẩm giá và quyền bình đẳng của người khác"),
    
    (36, 7, "Khiết tịnh"),
    (37, 7, "Hôn nhân"),

    (41, 8, "Đối với của cải của người khác"),
    (42, 8, "Đối với tài sản của công"),

    (45, 9, "Sống trung thực với tha nhân"),
    (46, 9, "Bảo vệ danh dự của tha nhân "),

    (49, 10, "Tin"),
    (50, 10, "Cậy"),
    (51, 10, "Mến"),

    (54, 11, "Tôn kính Danh Chúa"),
  
    (57, 12, "Thánh hóa ngày của Chúa");
    ''';
  }

  String seedReasons() {
    return '''
    INSERT INTO $relationalReasonsTable (relational_category_id, relational_subcategory_id, relational_subcategory_detail_id, is_grateful, name)
    VALUES
    (1, 1, 1, 1, "Tôi được khỏe mạnh."),
    (1, 1, 1, 1, "Tôi có điều kiện để tập luyện và bồi bổ sức khỏe."),
    (1, 1, 1, 1, "Tôi có thời gian để thư giãn và giải trí."),
    (1, 1, 1, 0, "Tôi ham ăn, ham chơi, không biết bảo vệ sức khoẻ mình có."),
    (1, 1, 1, 0, "Tôi không rèn luyện, nâng cao sức khỏe của mình."),
    (1, 1, 1, 0, "Tôi quá lao tâm và lao lực, không nghỉ ngơi hợp lý."),
    
    (1, 1, 2, 1, "Tôi được sống và sống dồi dào."),
    (1, 1, 2, 1, "Tôi có những điều kiện thuận lợi để phát triển sự sống của mình."),
    (1, 1, 2, 1, "Tôi ý thức đầy đủ và chu toàn trách nhiệm đối với sự sống của mình."),
    (1, 1, 2, 0, "Tôi không quý trọng sự sống của mình, mà muốn hủy hoại nó."),
    (1, 1, 2, 0, "Tôi không biết tận dụng những điều kiện sẵn có để phát triển sự sống của mình."),
    (1, 1, 2, 0, "Tôi không có đủ ý thức và trách nhiệm đối với sự sống của mình."),
    
   
    (1, 2, 5, 1, "Tôi hạnh phúc với giới tính của mình cũng như tính đặc thù của nó."),
    (1, 2, 5, 1, "Tôi biết chế ngự giác quan và trí tưởng tượng để giữ cho tâm hồn được trong sạch."),
    (1, 2, 5, 1, "Tôi làm chủ được bản năng tính dục của mình để có thể yêu thương trọn vẹn."),
    (1, 2, 5, 0, "Tôi không chấp nhận bản thân, không hài lòng về giới tính của mình."),
    (1, 2, 5, 0, "Tôi xem những sách báo, phim ảnh đồi truỵ khiến suy nghĩ mình không lành mạnh."),
    (1, 2, 5, 0, "Tôi không làm chủ được bản năng tính dục của mình."),
 
   
    (1, 3, 8, 1, "Tôi biết sống hài hòa với chính mình."),
    (1, 3, 8, 1, "Tôi biết bao dung với chính mình."),
    (1, 3, 8, 1, "Tôi biết tha thứ cho chính mình."),
    (1, 3, 8, 0, "Tôi quá khắt khe với chính mình."),
    (1, 3, 8, 0, "Tôi quá dễ dãi với chính mình."),
    (1, 3, 8, 0, "Tôi không thể tha thứ cho lỗi lầm của chính mình."),
    
    (1, 3, 9, 1, "Công sức lao động của mình tạo ra thành quả."),
    (1, 3, 9, 1, "Những của cải tôi được tặng hoặc thừa hưởng."),
    (1, 3, 9, 1, "Tôi biết sử dụng hợp lí và phát triển tài sản của mình. "),
    (1, 3, 9, 0, "Tôi không biết dùng sức lao động để tạo ra tài sản cách công chính."),
    (1, 3, 9, 0, "Tôi không biết gìn giữ những tài sản mình được hưởng."),
    (1, 3, 9, 0, "Tôi quá hà tiện hoặc phung phí tài sản mình có."),
    
    (1, 4, 11, 1, "Tôi biết những điểm mạnh và điểm yếu của bản thân."),
    (1, 4, 11, 1, "Tôi chấp nhận mình với cả cái hay lẫn cái dở."),
    (1, 4, 11, 1, "Tôi dám thể hiện chính mình cách tự tin, dù tôi chưa hoàn hảo."),
    (1, 4, 11, 0, "Tôi không tìm hiểu và chấp nhận bản thân mình với điểm mạnh và điểm yếu."),
    (1, 4, 11, 0, "Tôi quá kiêu ngạo vì những điểm mạnh của mình."),
    (1, 4, 11, 0, "Tôi quá tự ti với những điểm yếu của mình."),
    
    (1, 4, 12, 1, "Tôi ý thức được phẩm giá/ giá trị của mình."),
    (1, 4, 12, 1, "Tôi biết bảo vệ danh dự của mình."),
    (1, 4, 12, 1, "Tôi có điều kiện để phát huy giá trị của mình."),
    (1, 4, 12, 0, "Tôi chưa ý thức được phẩm giá/ giá trị của mình."),
    (1, 4, 12, 0, "Tôi không bảo vệ danh dự của mình."),
    (1, 4, 12, 0, "Tôi không tận dụng cơ hội để phát huy giá trị của mình."),
    

    (2, 5, 16, 1, "Tôi được sinh ra và lớn lên trong một gia đình hạnh phúc."),
    (2, 5, 16, 1, "Tôi được ông bà và cha mẹ yêu thương, và giáo dục nên người."),
    (2, 5, 16, 1, "Tôi nhận ra việc kính trọng và hiếu thảo với ông bà, cha mẹ khiến tôi trưởng thành hơn."),
    (2, 5, 16, 0, "Tôi không có lòng hiếu thảo và biết ơn ông bà cha mẹ."),
    (2, 5, 16, 0, "Tôi không có lòng tôn kính và cảm thông với ông bà cha mẹ."),
    (2, 5, 16, 0, "Tôi không trợ giúp ông bà và cha mẹ về vật chất cũng như tinh thần."),

    (2, 5, 17, 1, "Tôi có được phúc làm cha mẹ, ông bà."),
    (2, 5, 17, 1, "Tôi có được một gia đình sung mãn với lũ cháu đàn con."),
    (2, 5, 17, 1, "Tôi có được những người con, người cháu lành mạnh về thể xác/ tinh thần."),
    (2, 5, 17, 0, "Tôi chưa làm tròn trách nhiệm yêu thương, tôn trọng, nuôi dưỡng con cháu."),
    (2, 5, 17, 0, "Tôi chưa quan tâm hướng dẫn, giáo dục con cháu mặt đời và đạo."),
    (2, 5, 17, 0, "Tôi chưa làm gương sáng, cầu nguyện cho con cháu trong đời sống đức tin."),
  
    (2, 5, 18, 1, "Đất nước tôi giàu tài nguyên và xinh đẹp."),
    (2, 5, 18, 1, "Đất nước tôi được bình yên & tự do."),
    (2, 5, 18, 1, "Tôi có đủ can đảm và khả năng để bênh vực những người bị áp bức bất công."),
    (2, 5, 18, 0, "Tôi chưa tuân thủ luật pháp và vâng phục những quy định của chính quyền phù hợp với các đòi hỏi của luân lý."),
    (2, 5, 18, 0, "Tôi chưa tích cực xây dựng đất nước trở nên một xã hội công bằng, liên đới và tự do."),
    (2, 5, 18, 0, "Tôi chưa dám đấu tranh cho sự thật và bênh vực người bị áp bức bất công."),
    
    (2, 6, 31, 1, "Những sự sống tốt đẹp Chúa ban chung quanh tôi (gia đình, bạn bè, đồng nghiệp)."),
    (2, 6, 31, 1, "Mỗi mầm sống mới là một phép màu."),
    (2, 6, 31, 1, "Môi trường trật tự, an toàn xung quanh tôi là công sức/ ý thức của nhiều người."),
    (2, 6, 31, 0, "Tôi xúc phạm, gây tổn thương cho sức khỏe hay tinh thần của người khác."),
    (2, 6, 31, 0, "Tôi trực tiếp hay cộng tác vào việc phá thai."),
    (2, 6, 31, 0, "Tôi phá hoại hoặc gây nguy hiểm cho tính mạng của người khác."),
    
    (2, 6, 32, 1, "Anh em tôi và tôi được mang hình dạng của Chúa và ngang bằng nhau trước mắt Chúa."),
    (2, 6, 32, 1, "Anh em tôi và tôi được ban tặng những khả năng riêng để hỗ trợ nhau và đóng góp cho xã hội"),
    (2, 6, 32, 1, "Anh em tôi và tôi được tạo ra toàn vẹn theo cách riêng của từng cá nhân"),
    (2, 6, 32, 0, "Tôi lăng mạ, xúc phạm hay phá hoại phẩm giá mà Chúa ban cho anh em tôi"),
    (2, 6, 32, 0, "Tôi khinh thường anh em tôi vì họ khác tôi hay kém hơn tôi về mặt nào đó"),
    (2, 6, 32, 0, "Tôi làm gương xấu, cổ suý, gây dịp tội cho người khác"),
    
    (2, 7, 36, 1, "Tôi được hiểu biết và tôn trọng giới tính của người khác cũng như tính đặc thù của nó."),
    (2, 7, 36, 1, "Tôi được thúc đẩy để tìm hiểu và yêu thương người khác."),
    (2, 7, 36, 1, "Tôi làm chủ được bản năng tính dục để không làm tổn thương chính mình và người khác."),
    (2, 7, 36, 0, "Tôi không tôn trọng/ đùa cợt/ xâm hại giới tính người khác."),
    (2, 7, 36, 0, "Tôi lạm dụng tình dục trẻ vị thành niên."),
    (2, 7, 36, 0, "Tôi xâm phạm tình dục của người khác ngoài mong muốn của họ (dùng chức quyền, tiền bạc để cưỡng chế người khác giao cấu)."),
    (2, 7, 36, 0, "Tôi không làm chủ được bản năng tính dục, quan hệ ngoài hôn nhân và làm tổn thương người khác."),
    
    (2, 7, 37, 1, "Tôi có 1 người bạn đời tôn trọng, yêu thương và chung thuỷ."),
    (2, 7, 37, 1, "Bạn đời của tôi lắng nghe, thấu hiểu và bao dung cho tôi."),
    (2, 7, 37, 1, "Con cái chúng tôi được nuôi dạy trong luân lý Công Giáo."),
    (2, 7, 37, 0, "Tôi không chung thủy với người bạn đời, tôi ngoại tình."),
    (2, 7, 37, 0, "Tôi thiếu quan tâm và thờ ơ với gia đình."),
    (2, 7, 37, 0, "Tôi làm cho người bạn đời và con cái bị tổn thương do sự chuyên chế và bạo hành."),
   
    (2, 8, 41, 1, "Anh em tôi lao động lương thiện và tạo ra của cải, giá trị đẹp cho đời."),
    (2, 8, 41, 1, "Anh em tôi đối xử công bằng/ rộng lượng với tôi."),
    (2, 8, 41, 1, "Anh em tôi luôn chia sẻ và dạy tôi tinh thần sẻ chia. "),
    (2, 8, 41, 0, "Tôi tham lam và chiếm đoạt tài sản của người khác."),
    (2, 8, 41, 0, "Tôi gian lận, trốn thuế và tham nhũng."),
    (2, 8, 41, 0, "Tôi không biết sẻ chia với người khác."),

    (2, 8, 42, 1, "Những cơ sở hạ tầng, đường xá tốt đẹp tôi được sử dụng."),
    (2, 8, 42, 1, "Môi trường sạch đẹp, biển rừng Chúa ban."),
    (2, 8, 42, 1, "Có những chương trình bảo vệ môi trường, trồng rừng đang được thực hiện."),
    (2, 8, 42, 0, "Tôi lạm dụng, lãng phí hay phá hoại của công."),
    (2, 8, 42, 0, "Tôi gây ô nhiễm và hủy hoại môi trường."),
    (2, 8, 42, 0, "Tôi thờ ơ hay thậm chí chê bai các công tác cộng đồng, bảo vệ môi trường."),
   
    (2, 9, 45, 1, "Anh em tôi sống trung thực với nhau và với tôi."),
    (2, 9, 45, 1, "Tôi chấp nhận anh em tôi với những cái hay và cái dở của họ."),
    (2, 9, 45, 1, "Sự thật thuần túy mang lại cho tôi sự tự do khỏi những suy đoán nghi ngờ."),
    (2, 9, 45, 0, "Tôi không thành thực với anh em tôi trong lời nói và việc làm."),
    (2, 9, 45, 0, "Tôi bao che cho những hành vi xấu, không lên tiếng bảo vệ lẽ phải."),
    (2, 9, 45, 0, "Tôi suy diễn, cố tình bóp méo ý nghĩ và động cơ của người khác."),
    
    (2, 9, 46, 1, "Anh em tôi nói và làm có uy tín, danh dự."),
    (2, 9, 46, 1, "Dù còn nhiều hạn chế, khó khăn, anh em tôi vẫn giữ vững phẩm giá/ giá trị của mình."),
    (2, 9, 46, 1, "Tôi biết nhận ra lòng tốt của người khác và nêu lên điểm tốt của anh em mình."),
    (2, 9, 46, 0, "Tôi nói xấu hay vu khống anh em mình, xâm phạm thanh danh họ."),
    (2, 9, 46, 0, "Tôi chửi bới, miệt thị, dùng lời lẽ nặng nề để xúc phạm danh dự người khác."),
    (2, 9, 46, 0, "Tôi nịnh hót/ tâng bốc để thúc đẩy người khác làm điều không đúng."),
   
    (3, 10, 49, 1, "Tôi được biết Chúa là Thiên Chúa duy nhất."),
    (3, 10, 49, 1, "Lòng tôi được bình an khi tôi tin theo Chúa."),
    (3, 10, 49, 1, "Tôi được hướng dẫn và cộng tác vào công tác rao giảng tin mừng"),
    (3, 10, 49, 0, "Tôi còn u muội tin vào các hình thức bói toán, bùa ngải, đạo giáo khác."),
    (3, 10, 49, 0, "Tôi nghi ngờ, thử thách hoặc chối bỏ Chúa."),
    (3, 10, 49, 0, "Tôi thờ ơ trong việc tìm hiểu và đào sâu đức tin."),
    
    (3, 10, 50, 1, "Nơi Chúa/ nhà thờ tôi tìm được bình an."),
    (3, 10, 50, 1, "Chúa nhân từ, luôn khoan dung bảo bọc tôi."),
    (3, 10, 50, 1, "Chúa luôn che chở tôi khi tôi gặp gian nan thử thách."),
    (3, 10, 50, 0, "Tôi chưa cố gắng lao động, cộng tác với Chúa sau khi cầu nguyện."),
    (3, 10, 50, 0, "Tôi dễ chán nản, thất vọng và buông xuôi khi gặp khó khăn trong cuộc sống."),
    (3, 10, 50, 0, "Tôi ráng sức, tự dựa vào khả năng mình có mà quên Chúa đồng hành."),
    (3, 10, 51, 1, "Tôi nhận ra tình yêu Chúa dành cho tôi lớn lao hơn hết mọi sự."),
    (3, 10, 51, 1, "Tôi biết yêu mến Chúa hết lòng và hết sức."),
    (3, 10, 51, 1, "Tôi được hướng dẫn và nhận ra thánh ý Chúa."),
    (3, 10, 51, 0, "Tôi phủ nhận tình yêu của Chúa trong cuộc đời tôi."),
    (3, 10, 51, 0, "Tôi yêu mến tiền, danh vọng hơn yêu Chúa."),
    (3, 10, 51, 0, "Tôi lười biếng không chu toàn bổn phận đối với Thiên Chúa."),
    
    (3, 11, 54, 1, "Được gọi là người Kitô Hữu khiến tôi tự hào."),
    (3, 11, 54, 1, "Mọi việc trở nên ý nghĩa khi tôi làm vì Danh Chúa."),
    (3, 11, 54, 1, "Tôi có thể lấy Danh Chúa mà làm chứng cho sự thật."),
    (3, 11, 54, 0, "Tôi xấu hổ khi tuyên xưng Chúa"),
    (3, 11, 54, 0, "Tôi sử dụng Danh Chúa cách bất xứng/ làm việc xấu."),
    (3, 11, 54, 0, "Tôi xúc phạm đến Chúa là Đấng trung thành khi bội thề."),
   
    (3, 12, 57, 1, "Tôi có được những Chúa Nhật để thờ phượng Chúa."),
    (3, 12, 57, 1, "Tôi có được những Chúa Nhật để nghỉ ngơi và giải trí."),
    (3, 12, 57, 1, "Tôi có được những Chúa Nhật để chăm lo cho gia đình, văn hóa và xã hội."),
    (3, 12, 57, 0, "Tôi không tham dự tích cực và trọn vẹn Thánh lễ Chúa Nhật hoặc bỏ lễ mà không có lý do chính đáng."),
    (3, 12, 57, 0, "Tôi tham công tham việc đến nỗi lao động cả Chúa Nhật và các ngày lễ buộc."),
    (3, 12, 57, 0, "Tôi làm mất đi niềm vui và sự nghỉ ngơi cần thiết trong ngày của Chúa.");
    ''';
  }
}

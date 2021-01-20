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

  String seedCategories() {
    return '''
    INSERT INTO $relationalCategoriesTable (id, name, icon)
    VALUES
    (1, "Tôi", "${R.ic_myself}"),
    (2, "Tha nhân", "${R.ic_other_guys}"),
    (3, "Chúa", "${R.ic_god}");
    ''';
  }

  String seedSubcategories() {
    return '''
    INSERT INTO $relationalSubcategoriesTable (id, relational_category_id, name, icon)
    VALUES
    (1, 1, "Khả năng & Sức khoẻ", "${R.ic_health}"),
    (2, 1, "Của cải & Vật chất", "${R.ic_money}"),
    (3, 1, "Đặc quyền và sự yếu đuối", "${R.ic_human_rights}"),
    (4, 1, "Thời gian và hoàn cảnh", "${R.ic_time}"),
    
    (5, 2, "Những người luôn bên tôi", "${R.ic_family}"),
    (6, 2, "Với các thụ tạo & vật chất", "${R.ic_money}"),
    (7, 2, "Thời gian & hoàn cảnh", "${R.ic_time}"),
    (8, 2, "Quyền lợi của người khác", "${R.ic_human_rights}"),
    (9, 2, "Quan hệ cộng đồng", "${R.ic_commnunity}"),
    
    (10, 3, "Bổn phận tôn giáo", "${R.ic_religion}"),
    (11, 3, "Lời Chúa - tin mừng", "${R.ic_god_word}"),
    (12, 3, "Ý Chúa với ý tôi", "${R.ic_god_vs_me}")
    ''';
  }

  String seedSubcategoryDetails() {
    return '''
    INSERT INTO $relationalSubcategoryDetailsTable (id, relational_subcategory_id, description)
    VALUES
    (1, 1, "Sức khỏe của tôi ngày hôm nay"),
    (2, 1, "Đối với trí khôn/ tài năng của tôi"),
    (3, 1, "Đối với tiếng nói lương tâm"),
    (4, 1, "Công việc làm"),
    
    (5, 2, "Những tiện nghi, của cải tôi được thụ hưởng"),
    (6, 2, "Đồ ăn, thức uống tôi được hưởng dùng hôm nay"),
    (7, 2, "Áo quần, các vật dụng tôi có"),
    
    (8, 3, "Đối với quyền tự do của bản thân"),
    (9, 3, "Đối với những yếu đuối, sai phạm của bản thân (quyền được sai lầm)"),
    (10, 3, "Quyền được hạnh phúc"),
    
    (11, 4, "Đối với tương lai bất định"),
    (12, 4, "Đối với quá khứ đen tối"),
    (13, 4, "Đối với 24 giờ tôi được sống mỗi ngày"),
    (14, 4, "Những việc không may chẳng lành xảy đến với bản thân"),
    (15, 4, "Những việc may mắn đến với mình"),
    
    (16, 5, "Đối với người bạn đời"),
    (17, 5, "Đối với anh em"),
    (18, 5, "Đối với thầy cô"),
    (19, 5, "Đối với cha mẹ"),
    (20, 5, "Đối với đồng nghiệp"),
    (21, 5, "Với những người tôi mới gặp trong một ngày"),
    (22, 5, "Với lòng tự trọng, danh dự, nhân phẩm của người khác"),
    (23, 5, "Đối với con cái"),
    (24, 5, "Đối với chính quyền, luật pháp nơi tôi sống"),
    (25, 5, "Đối với bạn bè"),
    (26, 5, "Với người yêu"),
    (27, 5, "Đối với sự yêu thương mà người khác dành cho tôi"),
    (28, 5, "Đối với những công tác, nghĩa vụ xã hội"),
    (29, 5, "Đối với những người mà tôi yêu thương"),
    (30, 5, "Đối với những thần tượng/ người tôi ngưỡng mộ"),
  
    (31, 6, "Đối với môi trường"),
    (32, 6, "Đối với muôn vật/ thú nuôi"),
    (33, 6, "Đối với thụ tạo mà Chúa dựng nên"),
    (34, 6, "Đối với của cải của người khác (cha mẹ/ anh em tôi)"),
    (35, 6, "Đối với tài sản của chung (trường, công viên)"), 
    
    (36, 7, "Đối với thời gian của người khác"),
    (37, 7, "Đối với những người kém may mắn hơn (tàn tật, mồ côi, neo đơn)"),
    (38, 7, "Đối với những bất công, sai trái mà tôi đã chứng kiến"),
    (39, 7, "Đối với người khổ đau / buồn phiền"),
    (40, 7, "Đối với những điều tốt đẹp mà người khác làm cho tôi"), 

    (41, 8, "Đối với lỗi lầm của người khác"),
    (42, 8, "Đối với quyền tự do của người khác"),
    (43, 8, "Đối với quyền làm người, được bình đẳng và khoẻ mạnh"),
    (44, 8, "Tôn trọng người khác"),

    (45, 9, "Đối với những người yếu kém hơn tôi về sức khoẻ và trí thông minh"),
    (46, 9, "Đối với những người tôi chưa yêu thương (ghét bỏ, căm thù)"),
    (47, 9, "Đối với sự khác biệt giữa tôi và người khác"),
    (48, 9, "Đối với những người làm hại tôi"),

    (49, 10, "Việc cầu nguyện sáng tối"),
    (50, 10, "Đối với Thánh lễ Chúa Nhật và các Thánh lễ trọng"),
    (51, 10, "Xưng tội, rước lễ & các phép bí tích"),
    (52, 10, "Làm việc tông đồ"),
    (53, 10, "Công tác truyền giáo"),

    (54, 11, "Đối với luật yêu thương và lời Chúa"),
    (55, 11, "Đối với luật công bằng - Đức công bằng"),
    (56, 11, "Đức Tin"),

    (57, 12, "Đối với sự im lặng của Chúa, khi Ngài ko đáp lời tôi"),
    (58, 12, "Đối với những ơn lành Chúa ban");
    ''';
  }

  String seedReasons() {
    return '''
    INSERT INTO $relationalReasonsTable (relational_category_id, relational_subcategory_id, relational_subcategory_detail_id, is_grateful, name)
    VALUES
    (1, 1, 1, 1, "Vì sức khoẻ tôi tốt hơn nhiều người"),
    (1, 1, 1, 1, "Vì tôi có điều kiện tập luyện, bồi bổ để sức khoẻ tốt hơn"),
    (1, 1, 1, 1, "Vì tôi có những người yêu thuơng bên cạnh chăm sóc tôi"),
    (1, 1, 1, 1, "Vì dù tôi có thế nào, Chúa cũng luôn bên tôi"),
    (1, 1, 1, 0, "Vì những thói quen xấu của tôi làm ảnh hưởng đến sức khoẻ của tôi"),
    (1, 1, 1, 0, "Vì tôi chưa quý trọng sức khoẻ, mạng sống của mình"),
    (1, 1, 1, 0, "Vì tôi còn xem thường những lời khuyên răn, dặn dò bảo vệ sức khoẻ"),
    (1, 1, 2, 1, "Vì Chúa ban cho tôi trí khôn để nhận biết tốt xấu"),
    (1, 1, 2, 1, "Vì Chúa ban cho tôi khả năng để làm giàu cho bản thân và làm đẹp cho đời"),
    (1, 1, 2, 0, "Vì tôi sử dụng tài năng mình vào những việc không đúng đắn"),
    (1, 1, 2, 0, "Vì tôi còn lười biếng, không làm nhân lên nén vàng Chúa ban"),
    (1, 1, 3, 1, "Vì Chúa đặt để trong tôi lời nhắc nhở bản thân mình sống tốt hơn"),
    (1, 1, 3, 0, "Vì tôi làm nghịch lại với lương tâm mình"),
    (1, 1, 3, 0, "Tôi từ chối, phớt lờ đi tiếng nói lương tâm"),
    (1, 1, 4, 1, "Vì tôi đã và đang tạo ra những giá trị tốt đẹp"),
    (1, 1, 4, 1, "Vì tôi được làm những điều tôi thích"),
    (1, 1, 4, 1, "Vì luôn có cơ hội để tôi toàn tâm toàn ý góp sức"),
    (1, 1, 4, 0, "Vì tôi đã hưởng thụ nhiều hơn kiến tạo"),
    (1, 1, 4, 0, "Vì tôi còn phàn nàn, so đo qúa nhiều làm bản thân mình đau khổ"),
    (1, 1, 4, 0, "Vì tôi không quý trọng công việc tôi đang làm hiện tại"),
    (1, 2, 5, 1, "Vì tôi được đủ dùng"),
    (1, 2, 5, 1, "Vì tôi được sống sung túc, thoải mái"),
    (1, 2, 5, 1, "Vì tôi được tin tưởng, trao phó những của cải này"),
    (1, 2, 5, 0, "Vì tôi luôn so sánh, ghen tị làm bản thân mệt mỏi"),
    (1, 2, 5, 0, "Vì tôi không quý trọng những thứ tôi đang có"),
    (1, 2, 5, 0, "Vì tôi sử dụng của cải mình không hợp lí, hoang phí"),
    (1, 2, 5, 0, "Vì tôi sử dụng của cải mình làm điều không đúng"),
    (1, 2, 6, 1, "Vì tôi được đủ dùng hôm nay"),
    (1, 2, 6, 1, "Tôi được thưởng thức những món ăn tuyệt vời"),
    (1, 2, 6, 0, "Vì ham mê ăn uống làm sức khoẻ xấu đi"),
    (1, 2, 6, 0, "Vì tôi hoang phí thức ăn"),
    (1, 2, 7, 1, "Vì tôi có những quần áo, trang sức đẹp"),
    (1, 2, 7, 1, "Vì tôi có quần áo phù hợp, đủ ấm"),
    (1, 2, 7, 0, "Vì ham mê shopping làm ảnh hưởng tới vấn đề tài chính của gia đình"),
    (1, 2, 7, 0, "Vì tôi tiêu xài phung phí , không hợp lí"),
    (1, 2, 7, 0, "Vì tôi ăn mặc chưa phù hợp, chưa thể hiện sự tôn trọng khi cần thiết"),
    (1, 3, 8, 1, "Vì tôi có được tự do làm những điều tốt đẹp cho đời"),
    (1, 3, 8, 1, "Vì đất nước tôi được yên bình"),
    (1, 3, 8, 0, "Vì tôi còn làm nô lệ cho tiền bạc, vật chất, địa vị"),
    (1, 3, 8, 0, "Vì tôi còn lo sợ miệng người đời, không dám sống theo tin mừng"),
    (1, 3, 9, 1, "Vì tôi nhận ra mình chưa hoàn hảo để cố gắng hơn"),
    (1, 3, 9, 1, "Vì tôi luôn được Chúa tha thứ để tôi học cách thứ tha"),
    (1, 3, 9, 1, "Vì Chúa là sức mạnh của tôi"),
    (1, 3, 9, 0, "Vì tôi chưa khiêm tốn nhìn nhận lỗi lầm, từ chối thay đổi (dù được lương tâm đánh động)"),
    (1, 3, 9, 0, "Tôi đổ lỗi cho người khác để an ủi chính mình"),
    (1, 3, 9, 0, "Vì tôi chưa tìm sự thứ tha nơi Chúa, anh em, và bản thân tôi"),
    (1, 3, 10, 1, "Vì Chúa đã tạo dựng mọi sự trên trái đất thật hài hoà và đặt để tôi được hạnh phúc"),
    (1, 3, 10, 1, "Vì tôi tìm thấy hạnh phúc tự bên trong khi tôi biết yêu thương và cho đi"),
    (1, 3, 10, 1, "Vì tôi tìm được ý nghĩa đời mình"),
    (1, 3, 10, 0, "Vì tôi chưa cho phép mình được hạnh phúc, còn dày vò bản thân và những người xung quanh"),
    (1, 3, 10, 0, "Vì tôi đi tìm hạnh phúc nơi vật chất trần gian, nơi con người yếu đuối"),
    (1, 3, 10, 0, "Vì tôi còn kì vọng quá nhiều nơi người khác (gia đình, anh em) để làm tôi được hạnh phúc"),
    (1, 4, 11, 1, "Vì luôn có Chúa đồng hành cùng tôi vào ngày mai"),
    (1, 4, 11, 1, "Vì những điều tốt đẹp tôi có hôm nay"),
    (1, 4, 11, 0, "Vì tôi còn lo lắng, sợ hãi, chưa tin tuỏng cậy trông nơi Chúa"),
    (1, 4, 11, 0, "Vì tôi tin vào bói toán, tư vi, cung hoàng đạo dự báo tương lai"),
    (1, 4, 12, 1, "Vì quá khứ thất bại cho tôi những bài học hay"),
    (1, 4, 12, 1, "Vì tôi được tha thứ để sống tốt hơn hôm nay"),
    (1, 4, 12, 0, "Vì tôi còn để nỗi u sầu trong quá khứ lấn át hạnh phúc hôm nay"),
    (1, 4, 12, 0, "Vì tôi chưa tin tưởng vào sự khoan dung của Chúa"),
    (1, 4, 12, 0, "Vì quá sợ sệt quá khứ rồi quên đi hiện tại tốt đẹp"),
    (1, 4, 13, 1, "Vì tôi lại có 1 cơ hội mới để làm việc mình thích"),
    (1, 4, 13, 1, "Vì tôi có thời gian chăm sóc bản thân, thời gian nghỉ ngơi và làm việc hợp lí"),
    (1, 4, 13, 1, "Vì tôi có thời gian trò chuyện cùng Chúa"),
    (1, 4, 13, 1, "Vì tôi có thời gian chăm sóc người tôi yêu thương"),
    (1, 4, 13, 0, "vì tôi ham công tiếc việc/ ham chơi, chưa sắp xếp thời gian chăm sóc bản thân"),
    (1, 4, 13, 0, "Vì tôi dành quá nhiều thời gian vào các trang mạng xã hội, tv, tạp trí mà chưa làm xong kế hoạch trong ngày"),
    (1, 4, 13, 0, "Vì tôi quá bận rộn để tâm tình cùng Chúa/ quan tâm những người tôi yêu thương"),
    (1, 4, 14, 1, "Vì Chúa vẫn luôn đồng hành và ban ơn giúp tôi thăng tiến và mạnh mẽ hơn ngay trong nghịch cảnh"),
    (1, 4, 14, 1, "Vì với những vất vả hôm nay, tôi chọn sống trung thực để xây Nước Trời mai sau"),
    (1, 4, 14, 1, "Vì tôi biết Chúa sẽ không bỏ rơi tôi, tôi đang được học và rèn luyện cùng Ngài"),
    (1, 4, 14, 0, "Vì tôi lung lạc niềm tin nơi Chúa, xây dựng niềm tin sai lạc"),
    (1, 4, 14, 0, "Vì tôi chọn cách sống không trung thực để đối phó với nghịch cảnh"),
    (1, 4, 14, 0, "Vì tôi đi tìm bia rượu, chất kích thích để giải sầu"),
    (1, 4, 15, 1, "Vì muôn ơn huệ Chúa ban"),
    (1, 4, 15, 1, "Vì như 5 cô khôn ngoan, tôi có sự chuẩn bị đón nhận khi cơ hội đến"),
    (1, 4, 15, 1, "Vì luôn có những người quen, người không quen giúp đỡ tôi"),
    (1, 4, 15, 0, "Vì nhiều lúc tôi kiêu ngạo, nghĩ một mình làm nên tất cả"),
    (1, 4, 15, 0, "Vì tôi như 5 cô khờ dại, chưa chuẩn bị khi cơ hôi đến"),
    (1, 4, 15, 0, "Tôi luôn than thở vì những điều không may, không nhìn thấy những điiều tốt đẹp"),
    (2, 5, 16, 1, "Vợ chồng tôi yêu thương nhau"),
    (2, 5, 16, 1, "Vợ chồng tôi san sẻ, chăm sóc nhau"),
    (2, 5, 16, 1, "Vợ chồng tôi tha thứ cho nhau, giúp nhau thăng tiến hơn"),
    (2, 5, 16, 1, "Vợ chồng tôi lắng nghe và thấu hiểu nhau"),
    (2, 5, 16, 0, "Tôi bất hòa, cãi vã với người bạn đời"),
    (2, 5, 16, 0, "Tôi không chung thủy với người bạn đời"),
    (2, 5, 16, 0, "Tôi có lòng mơ tưởng người nam/nữ khác ngoài người bạn đời"),
    (2, 5, 16, 0, "Tôi ngoại tình"),
    (2, 5, 17, 1, "Anh chị em yêu thương giúp đỡ tôi"),
    (2, 5, 17, 1, "Anh chị em tha thứ lỗi lầm của tôi"),
    (2, 5, 17, 1, "Anh chị em khuyên bảo, giúp tôi trưởng thành hơn"),
    (2, 5, 17, 1, "Anh chị em chăm sóc tôi"),
    (2, 5, 17, 0, "Tôi chưa hòa thuận với anh chị em trong nhà"),
    (2, 5, 17, 0, "Tôi đối xử tệ với anh chị em"),
    (2, 5, 17, 0, "Tôi bất hòa, cãi nhau, tranh chấp với anh chị em"),
    (2, 5, 17, 0, "Tôi làm hại anh chị em mình"),
    (2, 5, 18, 1, "Thầy cô có những bài học hay, tiết học hay"),
    (2, 5, 18, 1, "Thầy cô khuyên răn, dạy bảo chúng tôi trở nên tốt hơn"),
    (2, 5, 18, 1, "Thầy cô giúp tôi tìm ra được chân lý, sự thật trong cuộc sống"),
    (2, 5, 18, 1, "Thầy cô công bằng với các học sinh"),
    (2, 5, 18, 0, "Tôi xúc phạm, vô lễ với thầy cô"),
    (2, 5, 18, 0, "Tôi không nhìn nhận công lao thầy cô 1 cách công bằng"),
    (2, 5, 19, 1, "Cha mẹ dạy dỗ tôi, giúp tôi trưởng thành hơn"),
    (2, 5, 19, 1, "Cha mẹ chăm sóc, quan tâm tôi"),
    (2, 5, 19, 1, "Cha mẹ tha thứ cho những lỗi lầm của tôi"),
    (2, 5, 19, 1, "Cha mẹ hy sinh giúp tôi được sống và sống dồi dào"),
    (2, 5, 19, 0, "Tôi không quan tâm đủ đến cha mẹ"),
    (2, 5, 19, 0, "Tôi giận dữ với cha mẹ"),
    (2, 5, 19, 0, "Tôi không tha thứ cho cha mẹ vì những bất toàn của cha mẹ"),
    (2, 5, 19, 0, "Tôi không tôn trọng, phụng dưỡng cha mẹ"),
    (2, 5, 20, 1, "Đồng nghiệp thân thiện"),
    (2, 5, 20, 1, "Đồng nghiệp giúp đỡ tôi trong công việc"),
    (2, 5, 20, 1, "Quản lý quan tâm và giúp tôi tiến bộ"),
    (2, 5, 20, 1, "Quản lý công bằng và tốt bụng với tôi"),
    (2, 5, 20, 0, "Tôi nói xấu 1 đồng nghiệp"),
    (2, 5, 20, 0, "Tôi trả đũa 1 đồng nghiệp"),
    (2, 5, 20, 0, "Tôi cãi nhau và lòng tôi đầy thù hằn người đồng nghiệp"),
    (2, 5, 20, 0, "Tôi không hợp tác, làm việc nhóm với đồng nghiệp"),
    (2, 5, 21, 1, "Những người giúp tôi trong công việc"),
    (2, 5, 21, 1, "Nụ cười của 1 đứa trẻ tình cờ gặp"),
    (2, 5, 21, 1, "Việc tốt tôi thấy trong ngày"),
    (2, 5, 21, 1, "Người khác nhường đường (nhường ghếm chỗ ngồi) cho tôi"),
    (2, 5, 21, 0, "Tôi ghét và hằn học những ai cản đường tôi khi chạy xe trên đường"),
    (2, 5, 21, 0, "Tôi không giúp đỡ những người khó khăn tôi gặp"),
    (2, 5, 21, 0, "Tôi đã làm tổn hại đến người khác và không chịu trách nhiệm cho hành động của mình"),
    (2, 5, 21, 0, "Tôi thô lỗ mắng nhiếc người phục vụ ở quán ăn"),
    (2, 5, 22, 1, "Vì họ dùng danh dự của mình để giúp đỡ tôi"),
    (2, 5, 22, 0, "Vì tôi chưa biết xin lỗi khi làm phạm tới người khác"),
    (2, 5, 22, 0, "Vì tôi xúc phạm đến danh dự, nhân phẩm của người khác"),
    (2, 5, 22, 0, "Vì tôi ko tôn trọng danh dự của người khác"),
    (2, 5, 23, 1, "Có con cái đến trong đời tôi, tôi được thiên chức làm cha mẹ"),
    (2, 5, 23, 1, "Con cái khoẻ mạnh, tốt lành"),
    (2, 5, 23, 1, "Con cái tha thứ cho những lỗi lầm của tôi"),
    (2, 5, 23, 0, "Tôi chưa khuyên răn, dạy dỗ con"),
    (2, 5, 23, 0, "Tôi chưa làm tròn trách nhiệm người làm cha mẹ"),
    (2, 5, 23, 0, "Tôi giận dữ, quát mắng con"),
    (2, 5, 24, 1, "VÌ có luật pháp bảo vệ sự yên ổn của nơi tôi sống"),
    (2, 5, 24, 1, "Vì Chúa giúp tôi phân biệt đúng sai và làm chứng cho sự thật khi càn thiết"),
    (2, 5, 24, 0, "Vì tôi không tuân theo pháp luật"),
    (2, 5, 24, 0, "Vì tôi hay phán xét, chỉ trích sai phạm của người khác"),
    (2, 5, 25, 1, "Những người bạn yêu thương, quan tâm tôi"),
    (2, 5, 25, 1, "Bạn bè giúp đỡ tôi khi khó khăn"),
    (2, 5, 25, 1, "Bạn bè đồng hành cùng tôi mỗi ngày"),
    (2, 5, 25, 1, "Bạn bè chia sẻ với tôi khi tôi có chuyện buồn, tâm sự"),
    (2, 5, 25, 0, "Tôi làm điều có lỗi với 1 người bạn"),
    (2, 5, 25, 0, "Tôi bắt nạt 1 người bạn"),
    (2, 5, 25, 0, "Tôi nói xấu 1 người bạn"),
    (2, 5, 25, 0, "Tôi không cứu giúp người bạn đang gặp khó khăn"),
    (2, 5, 26, 1, "Tôi yêu và được yêu"),
    (2, 5, 26, 1, "Tôi thấy tràn đầy sức sống, niềm vui"),
    (2, 5, 26, 1, "Tôi được quan tâm, yêu thương, trưởng thành"),
    (2, 5, 26, 1, "Tôi biết cho đi và nhận lại"),
    (2, 5, 26, 0, "Tôi lừa dối người yêu tôi"),
    (2, 5, 26, 0, "Tôi không tôn trọng người yêu tôi"),
    (2, 5, 26, 0, "Tôi lợi dụng người yêu tôi"),
    (2, 5, 26, 0, "Tôi phá bỏ sự sống (phá thai)"),
    (2, 5, 27, 1, "Vì người thân đã yêu thương, chăm lo cho tôi"),
    (2, 5, 27, 0, "Tôi chối bỏ sự yêu thương quan tâm mà người thân dành cho tôi"),
    (2, 5, 27, 0, "Tôi đáp lại sự yêu thương của người thân bằng sự thờ ơ, vô cảm hay hằn học"),
    (2, 5, 28, 1, "Vì có những người hi sinh thời gian làm đẹp cho đời"),
    (2, 5, 28, 1, "Vì tôi được tham gia góp ích cho đời"),
    (2, 5, 28, 0, "Vì tôi ngại ngùng đóng góp thời gian, công sức"),
    (2, 5, 28, 0, "Vì tôi còn chỉ trích những nguòi làm việc bác ái tốt đẹp cho đời"),
    (2, 5, 29, 1, "Vì Chúa đã ban cho tôi những người tôi yêu thương"),
    (2, 5, 29, 1, "Vì Chua đã ban cho họ sức khoẻ"),
    (2, 5, 29, 0, "Vì tôi chưa yêu thương họ đủ"),
    (2, 5, 29, 0, "Vì tôi làm họ buồn và đau lòng nhiều"),
    (2, 5, 29, 0, "Vì tôi vô tình xúc phạm đến họ"),
    (2, 5, 30, 1, "Vì họ đã tạo ra những giá trị tốt đẹp cho đời"),
    (2, 5, 30, 1, "Vì Chúa tạo ra những hình mẫu tốt đẹp, chăm chỉ lao động để tôi noi gương"),
    (2, 5, 30, 0, "Vì tôi thần tượng họ quá mức và làm tổn thương những người xung quanh tôi"),
    (2, 5, 30, 0, "Vì tôi vô tình làm theo những điều chưa tốt đẹp"),
    (2, 6, 31, 1, "Trái Đất cho tôi không khí để thở, cây xanh làm bóng mát, hoa trái thiên nhiên làm của cải lương thực"),
    (2, 6, 31, 1, "Thiên nhiên tươi đẹp để tôi nhìn ngắm"),
    (2, 6, 31, 1, "Khí hậu các mùa trong năm"),
    (2, 6, 31, 1, "Tôi trồng được 1 cây xanh"),
    (2, 6, 31, 0, "Tôi đã xả rác bừa bãi ra đường phố"),
    (2, 6, 31, 0, "Tôi dùng quá nhiều đồ nhựa"),
    (2, 6, 31, 0, "Tôi phá hoại rừng, cây, thiên nhiên"),
    (2, 6, 31, 0, "Tôi xài phung phí tài nguyên thiên nhiên"),
    (2, 6, 32, 1, "Tôi có những người bạn 4 chân dễ thương: mèo chó v.v..."),
    (2, 6, 32, 1, "Tôi chăm sóc cho thú cưng của mình"),
    (2, 6, 32, 1, "Thú nuôi mừng rỡ với tôi khi tôi trở về nhà"),
    (2, 6, 32, 1, "Thú nuôi an ủi, bên cạnh tôi khi tôi buồn phiền"),
    (2, 6, 32, 0, "Tôi bỏ bê không chăm sóc dù có nuôi chó mèo"),
    (2, 6, 32, 0, "Tôi hành hạ các loài động vật"),
    (2, 6, 33, 1, "Vì những điều kì diệu Chúa đã dụng nên cho nhân loại"),
    (2, 6, 33, 0, "Vì tôi chưa biết tôn trọng mọi loài mà Chúa dựng nên"),
    (2, 6, 34, 1, "Vì công sức lao động cuả họ tạo ra những thành quả tốt đẹp"),
    (2, 6, 34, 1, "Vì tôi luôn giữ đức công bằng, bồi thường xứng đáng nếu tôi làm hư hao"),
    (2, 6, 34, 1, "Vì họ san sẻ với tôi"),
    (2, 6, 34, 0, "Vì tôi còn đố kị"),
    (2, 6, 34, 0, "Vì tôi tìm cách cưỡng đoạt"),
    (2, 6, 34, 0, "Vì tôi vô tình hay cố ý làm hư hao tài sản của người khác"),
    (2, 6, 35, 1, "các anh công nhân, những người góp công sức xây dựng và giữ gìn sự sạch đẹp của tài sản chung"),
    (2, 6, 35, 0, "Tôi chưa biết giữ gìn sự sạch đẹp của tài sản chung"),
    (2, 6, 35, 0, "tôi còn xả rác"),
    (2, 6, 35, 0, "tôi làm hư hại"),
    (2, 7, 36, 1, "Vì họ dành thời gian để giúp đỡ tôi, bên cạnh tôi"),
    (2, 7, 36, 0, "Vì tôi chưa tôn trọng thời gian của người khác"),
    (2, 7, 36, 0, "Vì tôi cưỡng chế thời gian của người khác"),
    (2, 7, 37, 1, "Vì Chúa ban cho có những người may mắn như tôi để giúp đỡ những người có hoàn cảnh xấu hơn"),
    (2, 7, 37, 1, "Tôi dành 1 phần của cải, công sức để giúp đỡ những người kém may mắn hơn"),
    (2, 7, 37, 0, "Vì tôi đùa cợt về hoàn cảnh của người khác"),
    (2, 7, 37, 0, "Vì tôi chưa sống theo tinh thần Ki tô giáo, vị tha, bác ái"),
    (2, 7, 38, 1, "Tôi đứng lên cất tiếng nói để bảo vệ những nạn nhân"),
    (2, 7, 38, 1, "Lương tâm tôi cất tiếng để đấu tranh cho công bằng, sự thật"),
    (2, 7, 38, 1, "Tôi giúp đỡ những con người đang gặp hoạn nạn trong khả năng của tôi"),
    (2, 7, 38, 1, "Tôi trợ giúp góp chút sức để bảo vệ cho nạn nhân"),
    (2, 7, 38, 0, "Tôi im lặng khi thấy những bất công"),
    (2, 7, 38, 0, "Tôi chối bỏ trách nhiệm rằng tôi cũng cần phải đấu tranh cho sự công bằng"),
    (2, 7, 38, 0, "Tôi quy trách nhiệm lên những nạn nhân"),
    (2, 7, 38, 0, "Tôi không giúp đỡ khi những người gặp hoạn nạn kêu cứu"),
    (2, 7, 39, 1, "Vì tôi có khả năng để giúp đỡ họ"),
    (2, 7, 39, 1, "Vì có những lời kinh để tôi cầu nguyện cho họ"),
    (2, 7, 39, 1, "Tôi an ủi những khổ đau cho họ"),
    (2, 7, 39, 0, "Vì tôi chưa làm được gì cho họ"),
    (2, 7, 39, 0, "Vì tôi vui mừng trên nỗi đau của người khác"),
    (2, 7, 39, 0, "Vì tôi chưa an ủi được họ"),
    (2, 7, 39, 0, "Tôi thờ ơ, vô cảm trước những nôi đau khổ này"),
    (2, 7, 40, 1, "Tôi trân trọng và luôn thể hiện sự trân trọng của mình"),
    (2, 7, 40, 1, "Tôi đã biết ơn bằng lời nói và hành động cụ thể"),
    (2, 7, 40, 1, "Vì Chúa đã mang những người ấy đến với cuộc đời tôi"),
    (2, 7, 40, 0, "Tôi chưa biết nói lời cảm ơn tới người khác"),
    (2, 7, 40, 0, "Tôi chưa quý trọng những điều mà người khác làm cho tôi"),
    (2, 8, 41, 1, "vì Chúa tha thứ cho tôi, để tôi biết tha thứ cho người khác"),
    (2, 8, 41, 1, "Vì tôi đã dũng cảm để vượt qua tha thứ cho người khác và yêu thương mình hơn"),
    (2, 8, 41, 0, "Vì tôi tìm cách trả thù"),
    (2, 8, 41, 0, "Vì tôi đay nghiến người khác vì lỗi lầm đó"),
    (2, 8, 41, 0, "Vì tôi luôn nhắc cho họ nhớ lỗi của họ"),
    (2, 8, 41, 0, "Vì tôi phán xét họ"),
    (2, 8, 42, 1, "Vì họ dùng tự do của mình để bên cạnh, giúp đỡ hay bảo vệ tôi"),
    (2, 8, 42, 1, "Vì họ tự do yêu thương tôi vô điều kiện"),
    (2, 8, 42, 0, "Vì tôi không tôn trọng quyền tự do của người khác"),
    (2, 8, 42, 0, "Vì tôi dùng chức / quyền bắt người khác làm trái với ý muốn của họ"),
    (2, 8, 43, 1, "Vì tôi tôn trọng danh dự và sức khoẻ của người khác"),
    (2, 8, 43, 1, "Vì những người tôi yêu thương được khoẻ mạnh, bình an"),
    (2, 8, 43, 1, "Chúa tạo ra con người bình đẳng trước mặt Chúa không vì tuổi tác, giới tính, địa vị xã hội"),
    (2, 8, 43, 0, "Vì tôi làm tổn hại đến người khác (tinh thần cũng như thể lực)"),
    (2, 8, 43, 0, "Tôi cao ngạo, nghĩ mình cao siêu, tốt lành hơn người khác"),
    (2, 8, 43, 0, "Tôi khinh thường người khác vì tuổi tác, màu da, giới tính hay địa vị xã hội"),
    (2, 8, 43, 0, "Tôi ức hiếp người yếu thế hơn tôi (do sức khoẻ, địa vị)"),
    (2, 8, 44, 1, "Vì tôi có lời ca tiếng hát để ca tụng Chúa"),
    (2, 8, 44, 1, "Vì tôi có thể dùng lời nói của mình để xoa dịu nỗi đau của người khác"),
    (2, 8, 44, 1, "Vì tôi có thể dùng lời nói của mình để khen và khích lệ người khác"),
    (2, 8, 44, 1, "Vì tôi có thể dùng lời nói của mình để làm chứng cho sự thật"),
    (2, 8, 44, 0, "Vì tôi dùng ngôn ngữ của mình làm người khác đau khổ"),
    (2, 8, 44, 0, "Vì tôi nói sai sự thật, lừa đảo"),
    (2, 8, 44, 0, "Vì tôi lăng mạ, nguyền rủa, chửi bới người khác"),
    (2, 8, 44, 0, "Vì tôi nói hành, nói xấu người khác"),
    (2, 9, 45, 1, "Vì luôn có những người khoẻ mạnh như tôi để nâng đỡ những người yếu"),
    (2, 9, 45, 1, "Tôi dành thời gian, công sức để giúp đỡ họ"),
    (2, 9, 45, 1, "Tôi chia sẻ những khả năng của tôi để giúp họ tiến bộ hơn"),
    (2, 9, 45, 0, "Vì tôi bức hiếp kẻ yếu kém hơn mình"),
    (2, 9, 45, 0, "Vì tôi lăng mạ, nói xấu làm họ xấu hổ tủi thân"),
    (2, 9, 45, 0, "Vì tôi chưa biết giúp đỡ kẻ yếu"),
    (2, 9, 46, 1, "Tôi đã không để cho những con người này ám ảnh tôi trong tâm trí, cõi lòng"),
    (2, 9, 46, 1, "Tôi có cơ hội để chấp nhận con người khác, tập tha thứ cho người khác"),
    (2, 9, 46, 0, "Tâm trí tôi luôn hiện lên những ý nghĩ trả thù"),
    (2, 9, 46, 0, "Lòng tôi luôn khó chịu, bực dọc khi nghĩ về những người này"),
    (2, 9, 46, 0, "Tôi vu khống, hạ thấp danh dự những người này"),
    (2, 9, 46, 0, "Tôi trả thù những người này bằng lời nói, vũ lực"),
    (2, 9, 47, 1, "Tôi tôn trọng sự khác biệt"),
    (2, 9, 47, 1, "Tôi tìm ra được sự độc đáo và tài năng nơi người khác"),
    (2, 9, 47, 0, "tôi kì thị sự khác biêt"),
    (2, 9, 47, 0, "tôi đùa cợt, trọc quẹo vì sự khác biệt đó"),
    (2, 9, 47, 0, "tôi tảy chay sự khác biệt"),
    (2, 9, 48, 1, "Vì tôi đủ mạnh mẽ để đứng lên, làm chứng cho sự thật"),
    (2, 9, 48, 1, "Vì tôi biết tha thứ cho họ và tìm được bình an cho chính mình"),
    (2, 9, 48, 1, "Vì tôi biêt cầu nguyện cho họ"),
    (2, 9, 48, 0, "Vì sự căm ghét trong tôi làm tôi đánh mất sự bình an của mình"),
    (2, 9, 48, 0, "Vì tôi tìm mọi cách trả thù họ"),
    (2, 9, 48, 0, "Vì tôi còn lo sợ họ hơn kính sợ Chúa"),
    (3, 10, 49, 1, "Vì các linh mục đã soạn ra những kinh hay giúp tôi cầu nguyện dễ dàng hơn"),
    (3, 10, 49, 1, "Vì tôi có thời gian để thinh lặng tâm sự cùng Thiên Chúa"),
    (3, 10, 49, 1, "Vì tôi biết Ngài luôn sẵn sàng lắng nghe và trò chuyện cùng tôi"),
    (3, 10, 49, 0, "Vì tôi quên cầu nguyện với Chúa hôm nay"),
    (3, 10, 49, 0, "Vì tôi không tin tưởng việc cầu nguyện"),
    (3, 10, 50, 1, "Vì dù có bị từ chối nơi đâu, tôi cũng được đón nhận nơi nhà Chúa"),
    (3, 10, 50, 1, "Vì có cha xứ, các ca đoàn, đoàn thể, cá nhân đã mang lại 1 thánh lễ tốt đẹp và trang nghiêm"),
    (3, 10, 50, 1, "Do bầu khí trang nghiêm, lúc tĩnh lặng giúp tôi nói chuyện cùng Chúa dễ dàng hơn"),
    (3, 10, 50, 1, "Tôi được lãnh nhận các bí tích, các ơn lành Chúa ban"),
    (3, 10, 50, 0, "Vì tôi chưa trân trọng thời gian của người khác, tôi còn đến trễ"),
    (3, 10, 50, 0, "Vì tôi còn sao lãng, gây ồn ào, làm ảnh hưởng đến người khác"),
    (3, 10, 50, 0, "Vì tôi chưa yêu mến/ chưa đủ tin nên Thánh lễ chưa mang lại giá trị gì cho tôi"),
    (3, 10, 50, 0, "Vì tôi bỏ lễ Chúa nhật / lễ trọng"),
    (3, 10, 51, 1, "Vì những bí tích này mang lại cho tôi sức mạnh"),
    (3, 10, 51, 1, "Vì tôi biết Chúa luôn thứ tha và luôn muốn đồng hành cùng tôi"),
    (3, 10, 51, 1, "Vì tôi được Chúa yêu thương và ban ơn qua các phép bí tích"),
    (3, 10, 51, 0, "Vì tôi lơ là, không thường xuyên đến nhận lãnh bí tích được ban nhưng không"),
    (3, 10, 51, 0, "Vì tôi rước lễ khi trong lòng còn đầy thù hận, còn mắc những tội trọng"),
    (3, 10, 51, 0, "Vì nhiều năm qua tôi không đến nhà Chúa để xung tội/ lãnh các phép bí tích"),
    (3, 10, 52, 1, "Những việc tôi làm mang lại kết quả tốt đẹp"),
    (3, 10, 52, 1, "Chúa chọn và dùng tôi để danh Ngài được cả sáng"),
    (3, 10, 52, 0, "Khi làm việc cho Chúa, tôi còn ganh ghét, tranh chấp, bất hoà"),
    (3, 10, 52, 0, "Tôi làm cho danh mình, không phải danh Chúa"),
    (3, 10, 52, 0, "Tôi chưa sẵn sàng góp sức mình"),
    (3, 10, 53, 1, "Chúa dùng tôi làm công cụ"),
    (3, 10, 53, 1, "Tôi được mang lời Chúa đến với những tâm hồn khô cạn"),
    (3, 10, 53, 0, "Tôi quên đi rằng chỉ cần yêu thương anh em mình là tôi đang truyền giáo"),
    (3, 10, 53, 0, "Tôi còn hành sử thiếu yêu thương/ tha thứ/ bác ái giữa các anh em không cùng tôn giáo"),
    (3, 10, 53, 0, "Hành động và lời nói của tôi không đi cùng nhau, không làm chứng cho tình yêu"),
    (3, 11, 54, 1, "Vì tôi có kim chỉ nam để sống theo"),
    (3, 11, 54, 1, "Vì tôi biết mình được yêu thương trước hết"),
    (3, 11, 54, 1, "Vì yêu thương anh em, ngay cả người làm hại tôi đem lại cho tôi sự bình an trong tâm hồn"),
    (3, 11, 54, 0, "Vì thật khó để yêu thương người không yêu mình"),
    (3, 11, 54, 0, "VÌ tôi còn hờn ghét anh em mình"),
    (3, 11, 54, 0, "Vì tôi yếu đuối, chưa làm theo lời Chúa dạy"),
    (3, 11, 55, 1, "Lương tâm luôn nhắc nhở tôi không được lỗi đức công bằng"),
    (3, 11, 55, 1, "Dù khó khăn tới đâu, tôi luôn vuọt qua được và không lỗi đức công bằng"),
    (3, 11, 55, 1, "Tôi được giúp đỡ để ko lỗi đức công bằng"),
    (3, 11, 55, 0, "Tôi còn yếu đuối, tham lam sử dụng/ lấy thứ không phải của mình"),
    (3, 11, 55, 0, "Tôi dùng quyền hạn của mình làm lỗi phép công bằng"),
    (3, 11, 55, 0, "Tôi không công bằng trong công việc mỉnh đảm nhiệm"),
    (3, 11, 56, 1, "Tôi được biết Chúa"),
    (3, 11, 56, 1, "Tôi có Đức tin vững vàng nên tôi không lo sợ lời người ta nói"),
    (3, 11, 56, 0, "Lời nói, việc làm của người khác còn làm tôi nao núng, lo sợ"),
    (3, 11, 56, 0, "Tôi tin theo thầy bói, tử vi, etc."),
    (3, 11, 56, 0, "Tôi lo sợ, hùa theo đám đông vì những thông tin sai về ngày tận thế"),
    (3, 12, 57, 1, "Vì tôi biết Ngài luôn hiện diện và sẽ làm cho tôi những điều tốt đẹp nhất"),
    (3, 12, 57, 1, "Vi tôi biết Ngài đang gìn giữ tôi khỏi những sự xấu, và điều tốt đẹp hơn đang chờ tôi phía trước"),
    (3, 12, 57, 1, "Vì tôi có được niềm tui vững chắc nơi Chúa"),
    (3, 12, 57, 0, "Tôi trách móc Chúa và rời xa Ngài"),
    (3, 12, 57, 0, "Tôi quên mất sự hiện diện của Ngài mỗi ngày trong đời tôi"),
    (3, 12, 58, 1, "Vì Chúa luôn bên tôi, và lắng nghe tiếng tôi cầu xin"),
    (3, 12, 58, 1, "Người ban cho tôi dư tràn, hơn cả những gì tôi mong đợi"),
    (3, 12, 58, 0, "trách móc khi không được nhận đúng những gì tôi kêu cầu"),
    (3, 12, 58, 0, "Vì tôi quên ơn , không cảm tạ Chúa mà nghĩ là do sức của mình");
    ''';
  }
}

import 'package:beans/model/confession.dart';

class ConfessionDao {
  Future<Map<String, Map<String, List<ConfessionItem>>>>
      getListConfession() async {
    var list = getFakeData().groupBy(
      (p) => p.category,
    );
    var finalList = new Map<String, Map<String, List<ConfessionItem>>>();
    list.forEach((index, value) {
      var v = value.groupBy(
        (p) => p.name,
      );
      finalList[index] = v;
    });
    return finalList;
  }

  Future<int> confessDone() async {
    return 0;
  }

  // ngày bắt đầu bản xưng tôi
  Future<DateTime> getDateFrom() async {
    return DateTime.now();
  }

  List<ConfessionItem> getFakeData() {
    List<ConfessionItem> list = new List<ConfessionItem>();
    list.add(new ConfessionItem(1, 'Tôi không bảo vệ sức khoẻ',
        'Đối với bản thân', 'Sức khỏe', DateTime.now(), null));
    list.add(new ConfessionItem(10, 'Tôi không bảo vệ sức khoẻ',
        'Đối với bản thân', 'Sức khỏe', DateTime.now(), null));
    list.add(new ConfessionItem(11, 'Tôi không bảo vệ sức khoẻ',
        'Đối với bản thân', 'Sức khỏe', DateTime.now(), null));
    list.add(new ConfessionItem(12, 'Tôi không bảo vệ sức khoẻ',
        'Đối với bản thân', 'Sức khỏe', DateTime.now(), null));
    list.add(new ConfessionItem(2, 'Tôi làm việc qúa sức', 'Đối với bản thân',
        'Sức khỏe', DateTime.now(), null));
    list.add(new ConfessionItem(3, 'Tôi vui chơi quá độ', 'Đối với bản thân',
        'Sức khỏe', DateTime.now(), null));

    list.add(new ConfessionItem(4, 'Tôi nói dối', 'Đối với người khác',
        'Danh dự/ nhân phẩm', DateTime.now(), null));
    list.add(new ConfessionItem(5, 'Tôi thù ghét người khác',
        'Đối với người khác', 'Danh dự/ nhân phẩm', DateTime.now(), null));
    list.add(new ConfessionItem(6, 'Tôi vui trên nỗi đau của người khác',
        'Đối với người khác', 'Danh dự/ nhân phẩm', DateTime.now(), null));

    list.add(new ConfessionItem(7, 'Tôi không đi lễ', 'Đối với Chúa',
        'Thờ phượng', DateTime.now(), null));
    list.add(new ConfessionItem(8, 'Tôi dùng danh Chúa thề thốt',
        'Đối với Chúa', 'Thờ phượng', DateTime.now(), null));
    list.add(new ConfessionItem(9, 'Tôi mê tín dị đoan', 'Đối với Chúa',
        'Thờ phượng', DateTime.now(), null));
    return list;
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

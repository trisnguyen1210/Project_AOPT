import 'package:beans/dao/user_dao.dart';
import 'package:beans/model/user.dart';

class UserUsecase {
  String get name => _user.name;

  String get pin => _user.pin;

  User _user;
  final _userDao = UserDao();

  Future<bool> checkPin(String pin) async {
    await getUser();
    return _user.pin == pin;
  }

  getUser() async {
    _user = await _userDao.get();
    return _user;
  }
}

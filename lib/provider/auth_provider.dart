import 'package:beans/dao/user_dao.dart';
import 'package:beans/model/user.dart';
import 'package:flutter/material.dart';

enum ViewState { loading, register, home }

class AuthProvider with ChangeNotifier {
  // State: The challenge view state
  var _state = ViewState.loading;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  String get name => _user.name;
  String get pin => _user.pin;

  User _user;
  final _userDao = UserDao();

  AuthProvider() {
    _fetchState();
  }

  bool isPinValid(String pin) {
    return _user.pin == pin;
  }

  register(User user) async {
    await _userDao.create(user);
    _user = user;

    state = ViewState.home;
  }

  _fetchState() async {
    _user = await _userDao.get();

    if (_user == null) {
      state = ViewState.register;
      return;
    }

    state = ViewState.home;
  }
}

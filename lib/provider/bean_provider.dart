import 'package:beans/dao/target_dao.dart';
import 'package:beans/dao/user_dao.dart';
import 'package:beans/model/target.dart';
import 'package:beans/model/user.dart';
import 'package:flutter/material.dart';

class BeanProvider with ChangeNotifier {
  int get whiteBeanCount => _whiteBeanCount;

  int _whiteBeanCount;

  int get blackBeanCount => _blackBeanCount;

  int _blackBeanCount;

  Target get target => _target;

  Target _target;

  User _user;
  final _userDao = UserDao();
  final _targetDao = TargetDao();

  BeanProvider() {
    getUser();
    getTarget();
  }

  getUser() async {
    _user = await _userDao.get();
    _whiteBeanCount = _user.greenCount;
    _blackBeanCount = _user.blackCount;
    notifyListeners();
  }

  getTarget() async {
    _target = await _targetDao.getOrCreate();
    notifyListeners();
  }
}

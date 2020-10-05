import 'package:beans/dao/confession_dao.dart';
import 'package:beans/model/confession.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class ConfessProvider with ChangeNotifier {
  Map<String, Map<String, List<ConfessionItem>>> get listConfess =>
      _listConfess ?? new List<ConfessionItem>();

  Map<String, Map<String, List<ConfessionItem>>> _listConfess =
      new Map<String, Map<String, List<ConfessionItem>>>();

  String get dateFrom => _dateFrom;

  String _dateFrom;

  var showAlert = false;

  final _confessionDao = ConfessionDao();

  ConfessProvider() {
    fetchConfessList();
    getDateFrom();
  }

  fetchConfessList() async {
    _listConfess = await _confessionDao.getListConfession();
    notifyListeners();
  }

  getDateFrom() async {
    var date = await _confessionDao.getDateFrom();

    _dateFrom = formatDate(date, [dd, '/', mm, '/', yyyy]);
    notifyListeners();
  }

  confessDone() async {
    var update = await _confessionDao.confessDone();
  }
}

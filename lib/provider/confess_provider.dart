import 'package:beans/model/confession.dart';
import 'package:beans/usecase/confession_usecase.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class ConfessProvider with ChangeNotifier {
  Map<String, Map<String, List<ConfessionItem>>> get listConfess =>
      _listConfess ?? new List<ConfessionItem>();

  Map<String, Map<String, List<ConfessionItem>>> _listConfess =
      Map<String, Map<String, List<ConfessionItem>>>();

  String get dateFrom => _dateFrom;

  String _dateFrom;

  var showAlert = false;

  final _confessionUC = ConsfessionUsecase();

  ConfessProvider() {
    fetchConfessList();
    getDateFrom();
  }

  fetchConfessList() async {
    _listConfess = await _confessionUC.getListConfession();
    notifyListeners();
  }

  getDateFrom() async {
    var date = await _confessionUC.getDateFrom();

    _dateFrom = formatDate(date, [dd, '/', mm, '/', yyyy]);
    notifyListeners();
  }

  confessDone() async {
    await _confessionUC.confessDone();
  }
}

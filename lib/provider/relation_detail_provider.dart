import 'package:beans/dao/relational_item_dao.dart';
import 'package:beans/model/relational_item.dart';
import 'package:beans/model/relational_subcategory_detail.dart';
import 'package:flutter/material.dart';

import 'auth_provider.dart';

class RelationDetailProvider with ChangeNotifier {
  // Public properties
  final String categoryTitle;
  final String subcateTitle;

  List<Topic> topics = [];

  String get description => _detail.description;

  String get grateFulCount {
    if (_gratefulCount == 0) {
      return '';
    }
    return '+$_gratefulCount';
  }

  String get ungrateFulCount {
    if (_ungratefulCount == 0) {
      return '';
    }
    return '+$_ungratefulCount';
  }

  // Private properties
  final int _categoryId;
  final RelationalSubcategoryDetail _detail;
  final AuthProvider _authProvider;
  final RelationalItemDao _relationalItemDao = RelationalItemDao();

  int get _gratefulCount {
    final totalGratefulReason = _selectedGratefulReasonIdx?.length ?? 0;
    final otherGrateful = _otherGratefulReason.isSelected ? 1 : 0;

    return totalGratefulReason + otherGrateful;
  }

  int get _ungratefulCount {
    final totalUngratefulReason = _selectedUngratefulReasonIdx?.length ?? 0;
    final otherUngrateful = _otherUngratefulReason.isSelected ? 1 : 0;

    return totalUngratefulReason + otherUngrateful;
  }

  Bean _otherGratefulReason;
  Bean _otherUngratefulReason;

  List<int> _selectedGratefulReasonIdx = [];
  List<int> _selectedUngratefulReasonIdx = [];
  List<Bean> _gratefulReasons = [];
  List<Bean> _badReasons = [];

  RelationDetailProvider(
    this._categoryId,
    this.categoryTitle,
    this.subcateTitle,
    this._detail,
    this._authProvider,
  ) {
    _fetchData();
  }

  updateOtherReason(String title, bool isSelected, bool isGrateful) {
    if (isGrateful) {
      _updateOtherGratefulReason(title, isSelected);
    } else {
      _updateOtherUngratefulReason(title, isSelected);
    }
    notifyListeners();
  }

  addOrRemoveTheReason(int idx, bool isSelected, bool isGrateful) {
    if (isGrateful) {
      _addOrRemoveTheGrateful(idx, isSelected);
    } else {
      _addOrRemoveTheUngrateful(idx, isSelected);
    }
    notifyListeners();
  }

  submitRelation() async {
    List<RelationalItem> items = [];

    _gratefulReasons.forEach((reason) {
      final item = RelationalItem(
        createdAt: DateTime.now(),
        relationalCategoryId: _categoryId,
        relationalSubcategoryId: _detail.relationalSubcategoryId,
        relationalSubcategoryDetailId: _detail.id,
        isGrateful: true,
        isOther: false,
        name: reason.title,
      );
      items.add(item);
    });

    _badReasons.forEach((reason) {
      final item = RelationalItem(
        createdAt: DateTime.now(),
        relationalCategoryId: _categoryId,
        relationalSubcategoryId: _detail.relationalSubcategoryId,
        relationalSubcategoryDetailId: _detail.id,
        isGrateful: false,
        isOther: false,
        name: reason.title,
      );
      items.add(item);
    });

    if (_otherGratefulReason?.isSelected == true) {
      final item = RelationalItem(
        createdAt: DateTime.now(),
        relationalCategoryId: _categoryId,
        relationalSubcategoryId: _detail.relationalSubcategoryId,
        relationalSubcategoryDetailId: _detail.id,
        isGrateful: true,
        isOther: true,
        name: _otherGratefulReason.title,
      );
      items.add(item);
    }

    if (_otherUngratefulReason?.isSelected == true) {
      final item = RelationalItem(
        createdAt: DateTime.now(),
        relationalCategoryId: _categoryId,
        relationalSubcategoryId: _detail.relationalSubcategoryId,
        relationalSubcategoryDetailId: _detail.id,
        isGrateful: false,
        isOther: true,
        name: _otherUngratefulReason.title,
      );
      items.add(item);
    }

    await _relationalItemDao.createBeans(items);
    await _authProvider.updateBean(_gratefulCount, _ungratefulCount);
  }

  _updateOtherGratefulReason(String title, bool isSelected) {
    if (title != null) {
      _otherGratefulReason.title = title;
    }
    _otherGratefulReason.isSelected = isSelected;
  }

  _updateOtherUngratefulReason(String title, bool isSelected) {
    if (title != null) {
      _otherUngratefulReason.title = title;
    }
    _otherUngratefulReason.isSelected = isSelected;
  }

  _addOrRemoveTheGrateful(int idx, bool isSelected) {
    if (isSelected) {
      if (_selectedGratefulReasonIdx.contains(idx)) return;
      _selectedGratefulReasonIdx.add(idx);
    } else {
      _selectedGratefulReasonIdx.removeWhere((element) => element == idx);
    }
  }

  _addOrRemoveTheUngrateful(int idx, bool isSelected) {
    if (isSelected) {
      if (_selectedUngratefulReasonIdx.contains(idx)) return;
      _selectedUngratefulReasonIdx.add(idx);
    } else {
      _selectedUngratefulReasonIdx.removeWhere((element) => element == idx);
    }
  }

  _fetchData() {
    _detail.reasons.forEach((reason) {
      if (reason.isGrateful) {
        _gratefulReasons.add(Bean(reason.name, reason.isGrateful));
      } else {
        _badReasons.add(Bean(reason.name, reason.isGrateful));
      }
    });

    topics = [
      Topic("Tôi biết ơn vì", _gratefulReasons),
      Topic("Tôi trăn trở vì", _badReasons),
    ];

    _otherGratefulReason = Bean("title", true, isOther: true);
    _otherUngratefulReason = Bean("title", false, isOther: true);

    notifyListeners();
  }
}

class Topic {
  Topic(this.title, this.beans);

  final String title;
  List<Bean> beans;
}

class Bean {
  String title;
  final bool isGrateful;
  bool isOther;
  bool isSelected;

  Bean(
    this.title,
    this.isGrateful, {
    this.isOther = false,
    this.isSelected = false,
  });
}

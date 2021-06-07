import 'package:beans/dao/relational_item_dao.dart';
import 'package:beans/model/relational_item.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:flutter/material.dart';

class RelationDetailOtherProvider with ChangeNotifier {
  final String categoryTitle;
  final String subcateTitle;
  List<Topic> topics = [];
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

  final int _categoryId;
  final int _subcategoryId;
  final AuthProvider _authProvider;
  final RelationalItemDao _relationalItemDao = RelationalItemDao();
  int get _gratefulCount {
    var totalGratefulReason = 0;
    topics[0].beans.forEach((element) {
      if (element.title.isNotEmpty) {
        totalGratefulReason++;
      }
    });
    return totalGratefulReason;
  }

  int get _ungratefulCount {
    var totalUngratefulReason = 0;
    topics[1].beans.forEach((element) {
      if (element.title.isNotEmpty) {
        totalUngratefulReason++;
      }
    });

    return totalUngratefulReason;
  }

  RelationDetailOtherProvider(
    this._categoryId,
    this._subcategoryId,
    this.categoryTitle,
    this.subcateTitle,
    this._authProvider,
  ) {
    _fetchData();
  }

  submitRelation() async {
    List<RelationalItem> items = [];

    topics.forEach((topic) {
      topic.beans.forEach((bean) {
        if (bean.title.isEmpty) {
          return;
        }
        final item = RelationalItem(
          createdAt: DateTime.now(),
          relationalCategoryId: _categoryId,
          relationalSubcategoryId: _subcategoryId,
          relationalSubcategoryDetailId: null,
          isGrateful: bean.isGrateful,
          isOther: true,
          name: bean.title,
        );
        items.add(item);
      });
    });

    await _relationalItemDao.createBeans(items);
    await _authProvider.updateBean(_gratefulCount, _ungratefulCount);
  }

  updateBean(String title, int at, bool isGrateful) {
    if (isGrateful) {
      topics[0].beans[at].title = title;
    } else {
      topics[1].beans[at].title = title;
    }
    notifyListeners();
  }

  _fetchData() {
    topics = [
      Topic(
        "Tôi biết ơn vì",
        [Bean('', true), Bean('', true)],
      ),
      Topic(
        "Tôi trăn trở vì",
        [Bean('', false), Bean('', false)],
      ),
    ];

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
  bool isGrateful;

  Bean(
    this.title,
    this.isGrateful,
  );
}

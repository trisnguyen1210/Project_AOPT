import 'package:beans/dao/relational_category_dao.dart';
import 'package:beans/dao/relational_reason_dao.dart';
import 'package:beans/dao/relational_subcategory_dao.dart';
import 'package:beans/dao/relational_subcategory_detail_dao.dart';
import 'package:beans/model/relational_category.dart';

class CategoryUsecase {
  final _categoryDao = RelationalCategoryDao();
  final _subcategoryDao = RelationalSubcategoryDao();
  final _detailSubcategoryDao = RelationalSubcategoryDetailDao();
  final _reasonDao = RelationalReasonDao();

  Future<List<RelationalCategory>> getAll() async {
    var categories = await _categoryDao.getList();
    int catCount = categories.length;

    for (int i = 0; i < catCount; i++) {
      // for each category, add the list of subcategory
      var subcategories =
          await _subcategoryDao.getListByCategoryId(categories[i].id);

      int subcatCount = subcategories.length;

      // for each subcategory, add the list of details
      for (int i = 0; i < subcatCount; i++) {
        var details = await _detailSubcategoryDao
            .getListBySubcategoryId(subcategories[i].id);

        int detailCount = details.length;

        // for each details, add the list of reason
        for (int i = 0; i < detailCount; i++) {
          var reasons = await _reasonDao.getByDetailID(details[i].id);
          details[i].reaons = reasons;
        }

        subcategories[i].details = details;
      }

      categories[i].subcategories = subcategories;
    }

    return categories;
  }
}

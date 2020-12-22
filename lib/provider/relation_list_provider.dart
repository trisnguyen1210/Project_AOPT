import 'package:beans/model/relational_category.dart';
import 'package:beans/usecase/category_usecase.dart';

class RelationListProvider {
  final _categoryUC = CategoryUsecase();

  Future<List<RelationalCategory>> fetchCategories() async {
    return await _categoryUC.getAll();
  }
}

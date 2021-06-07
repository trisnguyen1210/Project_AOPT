import 'package:beans/model/relational_subcategory_detail.dart';

class RelationalSubcategory {
  final int id;
  final int relationalCategoryId;
  final String name;
  final String description;
  List<RelationalSubcategoryDetail> details = [];

  RelationalSubcategory({
    this.id,
    this.relationalCategoryId,
    this.name,
    this.description,
  });

  factory RelationalSubcategory.fromMap(Map<String, dynamic> data) =>
      RelationalSubcategory(
        id: data['id'],
        relationalCategoryId: data['relational_category_id'],
        name: data['name'],
        description: data['description'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': this.name,
      'description': this.description,
      'relational_category_id': this.relationalCategoryId,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}

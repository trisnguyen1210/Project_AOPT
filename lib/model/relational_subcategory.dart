import 'package:beans/model/relational_subcategory_detail.dart';

class RelationalSubcategory {
  final int id;
  final int relationalCategoryId;
  final String name;
  final String icon;
  List<RelationalSubcategoryDetail> details = [];

  RelationalSubcategory({
    this.id,
    this.relationalCategoryId,
    this.name,
    this.icon,
  });

  factory RelationalSubcategory.fromMap(Map<String, dynamic> data) =>
      RelationalSubcategory(
        id: data['id'],
        relationalCategoryId: data['relational_category_id'],
        name: data['name'],
        icon: data['icon'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': this.name,
      'icon': this.icon,
      'relational_category_id': this.relationalCategoryId,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}

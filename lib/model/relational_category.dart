import 'package:beans/model/relational_subcategory.dart';

class RelationalCategory {
  final int id;
  final String name;
  final String icon;
  List<RelationalSubcategory> subcategories = [];

  RelationalCategory({
    this.id,
    this.name,
    this.icon,
  });

  factory RelationalCategory.fromMap(Map<String, dynamic> data) =>
      RelationalCategory(
        id: data['id'],
        name: data['name'],
        icon: data['icon'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': this.name,
      'icon': this.icon,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}

import 'package:beans/model/relational_reason.dart';

class RelationalSubcategoryDetail {
  final int id;
  int relationalSubcategoryId;
  String description;

  List<RelationalReason> reaons = [];

  RelationalSubcategoryDetail({
    this.id,
    this.relationalSubcategoryId,
    this.description,
  });

  factory RelationalSubcategoryDetail.fromMap(Map<String, dynamic> data) =>
      RelationalSubcategoryDetail(
        id: data['id'],
        description: data['description'],
        relationalSubcategoryId: data['relational_subcategory_id'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'description': this.description,
      'relational_subcategory_id': this.relationalSubcategoryId,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}

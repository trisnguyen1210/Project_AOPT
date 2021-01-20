class RelationalItem {
  final int id;
  final DateTime createdAt;
  final int relationalCategoryId;
  final int relationalSubcategoryId;
  final int relationalSubcategoryDetailId;
  final bool isGrateful;
  final bool isOther;
  final String name;
  final bool isConfess;

  RelationalItem(
      {this.id,
      this.createdAt,
      this.relationalCategoryId,
      this.relationalSubcategoryId,
      this.relationalSubcategoryDetailId,
      this.isGrateful,
      this.isOther,
      this.name,
      this.isConfess});

  factory RelationalItem.fromMap(Map<String, dynamic> data) => RelationalItem(
        id: data['id'],
        createdAt: DateTime.tryParse(data['created_at']),
        relationalCategoryId: data['relational_category_id'],
        relationalSubcategoryId: data['relational_subcategory_id'],
        relationalSubcategoryDetailId: data['relational_subcategory_detail_id'],
        isGrateful: data['is_grateful'] == 1 ? true : false,
        isOther: data['is_other'] == 1 ? true : false,
        name: data['name'],
        isConfess: data['is_Confess'] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'created_at': this.createdAt.toIso8601String(),
      'relational_category_id': this.relationalCategoryId,
      'relational_subcategory_id': this.relationalSubcategoryId,
      'relational_subcategory_detail_id': this.relationalSubcategoryDetailId,
      'is_grateful': this.isGrateful ? 1 : 0,
      'is_other': this.isOther ? 1 : 0,
      'name': this.name,
      'is_Confess': this.isConfess ? 1 : 0,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}

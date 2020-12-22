class RelationalReason {
  final int id;
  final int relationalCategoryId;
  final int relationalSubcategoryId;
  final int relationalSubcategoryDetailId;
  final bool isGrateful;
  final bool isOther;
  final String name;

  RelationalReason({
    this.id,
    this.relationalCategoryId,
    this.relationalSubcategoryId,
    this.relationalSubcategoryDetailId,
    this.isGrateful,
    this.isOther = false,
    this.name,
  });

  factory RelationalReason.fromMap(Map<String, dynamic> data) =>
      RelationalReason(
        id: data['id'],
        relationalCategoryId: data['relational_category_id'],
        relationalSubcategoryId: data['relational_subcategory_id'],
        relationalSubcategoryDetailId: data['relational_subcategory_detail_id'],
        isGrateful: data['is_grateful'] == 1 ? true : false,
        isOther: data['is_other'] == 1 ? true : false,
        name: data['name'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'relational_category_id': this.relationalCategoryId,
      'relational_subcategory_id': this.relationalSubcategoryId,
      'relational_subcategory_detail_id': this.relationalSubcategoryDetailId,
      'is_grateful': this.isGrateful ? 1 : 0,
      'is_other': this.isOther ? 1 : 0,
      'name': this.name,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}

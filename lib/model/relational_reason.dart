class RelationalReason {
  final int id;
  final int relationalCategoryId;
  final int relationalSubcategoryId;
  final bool isGrateful;
  final bool isOther;
  final String name;

  RelationalReason({
    this.id,
    this.relationalCategoryId,
    this.relationalSubcategoryId,
    this.isGrateful,
    this.isOther = false,
    this.name,
  });
}

class ConfessionItem {
  final int id;
  final String name;
  final String category;
  final String subCategory;
  final DateTime createdAt;
  final DateTime confessAt;

  ConfessionItem(this.id, this.name, this.category, this.subCategory,
      this.createdAt, this.confessAt);
}

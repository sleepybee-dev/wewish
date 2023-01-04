class CategoryItem {
  int categoryId = -1;
  String category = "";
  String part1 = "";
  String part2 = "";

  CategoryItem();

  CategoryItem.fromJson(Map<String, dynamic> json)
      : categoryId = json['categoryId'] == null ? -1 : json['categoryId'] as int,
        category = json['category'] == null ? '' : json['category'] as String,
        part1 = json['part1'] == null ? '' : json['part1'] as String,
        part2 = json['part2'] == null ? '' : json['part2'] as String;

  Map<String, dynamic> toJson() => <String, dynamic> {
    'categoryId' : categoryId,
    'category': category,
    'part1' : part1,
    'part2' : part2
  };
}
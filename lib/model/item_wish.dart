class WishItem {
  String name = '';
  String url = '';
  String category = '';
  int categoryId = 0;
  int price = 0;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  WishItem({required this.name, required this.url, required this.price, required this.createdDate});

  WishItem.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        url = json['url'] as String,
        category = json['category'] == null ? '카테고리없음' : json['category'] as String,
        categoryId = json['categoryId'] == null ? -1 : json['categoryId'] as int,
        price = json['price'] as int,
        createdDate = json['createdDate'] == null ? DateTime.now() : json['createdDate'] as DateTime,
        modifiedDate = json['modifiedDate'] == null ? DateTime.now() : json['modifiedDate'] as DateTime;

  // factory WishItem.toMap(WishItem wishItem) {
  //   return {
  //     'name': wishItem.name,
  //     'url': wishItem.url,
  //     'price': wishItem.price
  //   }
  // }
}

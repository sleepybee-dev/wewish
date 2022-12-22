class WishItem {
  String name = '';
  String url = '';
  int price = 0;

  WishItem({required this.name, required this.url, required this.price});

  WishItem.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        url = json['url'] as String,
        price = json['price'] as int;

  // factory WishItem.toMap(WishItem wishItem) {
  //   return {
  //     'name': wishItem.name,
  //     'url': wishItem.url,
  //     'price': wishItem.price
  //   }
  // }
}

import 'package:wewish/model/item_category.dart';

class WishItem {
  String name = '';
  String url = '';
  CategoryItem category = CategoryItem();
  int price = 0;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  WishItem();

  WishItem.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        url = json['url'] as String,
        category = json['category'] == null ? CategoryItem() : CategoryItem.fromJson(json['category']),
        price = json['price'] as int,
        createdDate = json['createdDate'] == null ? DateTime.now() : json['createdDate'] as DateTime,
        modifiedDate = json['modifiedDate'] == null ? DateTime.now() : json['modifiedDate'] as DateTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name' : name,
    'url': url,
    'category': category.toJson(),
    'price': price,
    'createdDate': createdDate,
    'modifiedDate': modifiedDate
  };
}

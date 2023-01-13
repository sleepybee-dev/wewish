import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_category.dart';

class WishItem {
  String name = '';
  String url = '';
  CategoryItem category = CategoryItem();
  int price = 0;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  bool isBooked = false;
  bool isChecked = false;
  bool isReceived = false;
  String giver = '';

  WishItem();

  WishItem.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        url = json['url'] as String,
        category = json['category'] == null
            ? CategoryItem()
            : CategoryItem.fromJson(json['category']),
        price = json['price'] as int,
        isBooked = json['reservation_status'] as bool,
        isChecked = json['check_status'] as bool,
        isReceived = json['gift_status'] as bool,
        giver = json['giver'] as String,
        createdDate = json['createdDate'] == null
            ? DateTime.now()
            : (json['createdDate'] as Timestamp).toDate(),
        modifiedDate = json['modifiedDate'] == null
            ? DateTime.now()
            : (json['modifiedDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'reservation_status': isBooked,
        'check_status': isChecked,
        'gift_status': isReceived,
        'giver': giver,
        'name': name,
        'url': url,
        'category': category.toJson(),
        'price': price,
        'createdDate': createdDate,
        'modifiedDate': modifiedDate
      };
}

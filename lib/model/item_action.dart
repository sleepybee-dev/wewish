
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_category.dart';
import 'package:wewish/model/item_user.dart';

class ActionItem {
  UserItem wishUser = UserItem();
  String productName = '';
  String url = '';
  CategoryItem category = CategoryItem();
  int price = 0;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  bool isBooked = false;
  bool isChecked = false;
  bool isReceived = false;

  ActionItem();

  ActionItem.fromJson(Map<String, dynamic> json)
      : wishUser = json['wishUser'] as UserItem,
        productName = json['name'] as String,
        url = json['url'] as String,
        category = json['category'] == null
            ? CategoryItem()
            : CategoryItem.fromJson(json['category']),
        price = json['price'] as int,
        isBooked = json['reservation_status'] as bool,
        isChecked = json['check_status'] as bool,
        isReceived = json['gift_status'] as bool,
        createdDate = json['createdDate'] == null
            ? DateTime.now()
            : (json['createdDate'] as Timestamp).toDate(),
        modifiedDate = json['modifiedDate'] == null
            ? DateTime.now()
            : (json['modifiedDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() => <String, dynamic>{
    'wish_user': wishUser.toJson(),
    'reservation_status': isBooked,
    'check_status': isChecked,
    'gift_status': isReceived,
    'name': productName,
    'url': url,
    'category': category.toJson(),
    'price': price,
    'createdDate': createdDate,
    'modifiedDate': modifiedDate
  };
}

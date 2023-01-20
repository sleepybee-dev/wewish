import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_category.dart';
import 'package:wewish/model/item_user.dart';

class WishItem {
  String productName = '';
  String url = '';
  CategoryItem category = CategoryItem();
  int price = 0;
  DateTime createdDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();

  bool isBooked = false;
  bool isPresented = false;
  bool isReceived = false;
  UserItem? actionUser;

  WishItem();

  WishItem.fromJson(Map<String, dynamic> json)
      : productName = json['name'] as String,
        url = json['url'] as String,
        category = json['category'] == null
            ? CategoryItem()
            : CategoryItem.fromJson(json['category']),
        price = json['price'] as int,
        isBooked = json['isBooked'] as bool,
        isPresented = json['isPresented'] as bool,
        isReceived = json['isReceived'] as bool,
        actionUser = json['actionUser'] == null
            ? null
            : UserItem.fromJson(json['actionUser']),
        createdDate = json['createdDate'] == null
            ? DateTime.now()
            : (json['createdDate'] as Timestamp).toDate(),
        modifiedDate = json['modifiedDate'] == null
            ? DateTime.now()
            : (json['modifiedDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isBooked': isBooked,
        'isPresented': isPresented,
        'isReceived': isReceived,
        'actionUser': actionUser != null ? actionUser!.toJson() : null,
        'name': productName,
        'url': url,
        'category': category.toJson(),
        'price': price,
        'createdDate': createdDate,
        'modifiedDate': modifiedDate
      };
}

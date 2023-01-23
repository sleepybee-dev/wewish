import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_action.dart';
import 'package:wewish/model/item_category.dart';
import 'package:wewish/model/item_user.dart';

class WishItem {
  int wishIndex = -1;
  String productName = '';
  String url = '';
  CategoryItem category = CategoryItem();
  int price = 0;
  DateTime createdDate = DateTime.now().toLocal();
  DateTime modifiedDate = DateTime.now().toLocal();

  List<ActionItem> actionList = [];
  UserItem? wishUser;

  WishItem();

  WishItem.fromJson(Map<String, dynamic> json)
       : productName = json['name'] as String,
        url = json['url'] as String,
        category = json['category'] == null
            ? CategoryItem()
            : CategoryItem.fromJson(json['category']),
        price = json['price'] as int,
        wishUser = json['wishUser'] == null
            ? null
            : UserItem.fromJson(json['wishUser']),
        actionList = json['actionList'] == null ? [] : (json['actionList'] as List<dynamic>).map((e)=>ActionItem.fromJson(e)).toList(),
        createdDate = json['createdDate'] == null
            ? DateTime.now()
            : (json['createdDate'] as Timestamp).toDate(),
        modifiedDate = json['modifiedDate'] == null
            ? DateTime.now()
            : (json['modifiedDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'wishUser': wishUser != null ? wishUser!.toJson() : null,
        'name': productName,
        'url': url,
        'category': category.toJson(),
        'price': price,
        'createdDate': createdDate,
        'modifiedDate': modifiedDate,
        'actionList' : actionList.map((e)=> e.toJson()).toList()
      };
}

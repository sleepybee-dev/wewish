import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/model/item_category.dart';

class GiveItem {
  String productName = '';
  String url = '';
  bool isBooked = false;
  bool isChecked = false;
  bool isSended = false;
  String receiver = '';

  GiveItem();

  GiveItem.fromJson(Map<String, dynamic> json)
      : productName = json['name'] as String,
        url = json['url'] as String,
        isBooked = json['isBooked'] as bool,
        isChecked = json['isChecked'] as bool,
        isSended = json['isSended'] as bool,
        receiver = json['receiver'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isBooked': isBooked,
        'isChecked': isChecked,
        'isSended': isSended,
        'receiver': receiver,
        'productName': productName,
        'url': url,
      };
}

import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';

class RegistryItem {
  UserItem user;
  List<WishItem> wishList = [];

  RegistryItem({required this.user, required this.wishList});

  RegistryItem.fromJson(Map<String, dynamic> json) :
      user = UserItem.fromJson(json['user']),
      wishList = (json['wishlist'] as List<dynamic>)
          .map((e) => WishItem.fromJson(e as Map<String, dynamic>))
          .toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user' : user
  };
}
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';

class RegistryItem {
  String? registryId;
  UserItem user;
  List<WishItem> wishList = [];
  List<WishItem> actions = [];

  RegistryItem(
      {required this.user, required this.wishList, required this.actions});

  RegistryItem.fromJson(Map<String, dynamic> json)
      : user = UserItem.fromJson(json['user']),
        wishList = (json['wishlist'] as List<dynamic>)
            .map((e) => WishItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        actions = json['actions'] == null ? [] : (json['actions'] as List<dynamic>)
            .map((e) => WishItem.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'wishlist': wishList,
        'actions': actions,
      };
}

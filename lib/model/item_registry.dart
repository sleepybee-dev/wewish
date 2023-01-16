import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/model/item_give.dart';

class RegistryItem {
  String? registryId;
  UserItem user;
  List<WishItem> wishList = [];
  List<GiveItem> giveList = [];

  RegistryItem(
      {required this.user, required this.wishList, required this.giveList});

  RegistryItem.fromJson(Map<String, dynamic> json)
      : user = UserItem.fromJson(json['user']),
        wishList = (json['wishlist'] as List<dynamic>)
            .map((e) => WishItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        giveList = (json['givelist'] as List<dynamic>)
            .map((e) => GiveItem.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user': user,
        'wishlist': wishList,
        'givelist': giveList,
      };
}

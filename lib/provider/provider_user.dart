import 'package:flutter/material.dart';
import 'package:wewish/model/item_user.dart';

class UserProvider extends ChangeNotifier {
  UserItem? _curUser;

  UserItem? get user => _curUser;

  updateLoginUser(UserItem userItem) {
    _curUser = userItem;
  }
}
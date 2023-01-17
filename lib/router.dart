import 'package:flutter/material.dart';
import 'package:wewish/home.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/page/page_edit_profile.dart';
import 'package:wewish/page/page_mypage_login.dart';
import 'package:wewish/page/page_wish_edit.dart';
import 'package:wewish/page/page_wishlist.dart';
import 'package:wewish/page/page_settings.dart';


const String home = '/';
const String wishlistPage = '/wishlist';
const String wishEditPage = '/edit-wish';
const String settingsPage = '/my-page/settings';
const String profileEditPage = '/my-page/edit-profile';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case wishlistPage:
      var registryArgument = settings.arguments as RegistryItem;
      return MaterialPageRoute(builder: (context) => WishListPage(registryItem: registryArgument));
    case settingsPage:
      if (settings.arguments != null && settings.arguments is UserItem) {
        return MaterialPageRoute(builder: (context) => SettingsPage(userItem: settings.arguments as UserItem,));
      }
      return MaterialPageRoute(builder: (context) => const MyPageLogin());
    case wishEditPage:
      if (settings.arguments != null && settings.arguments is String) {
        return MaterialPageRoute(builder: (context) => WishEditPage(url: settings.arguments as String));
      }
      return MaterialPageRoute(builder: (context) => WishEditPage());
    case profileEditPage:
      if (settings.arguments != null && settings.arguments is UserItem) {
        return MaterialPageRoute(builder: (context) => EditProfile(userItem: settings.arguments as UserItem,));
      }
      return MaterialPageRoute(builder: (context) => const MyPageLogin());
    default:
      return MaterialPageRoute(builder: (context) => const Home());
  }
}
import 'package:flutter/material.dart';
import 'package:wewish/home.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/page/page_wish_setting.dart';
import 'package:wewish/page/page_wishlist.dart';
import 'package:wewish/page/page_settings.dart';


const String home = '/';
const String wishlistPage = '/wishlist';
const String wishSettingPage = '/wish-setting';
const String settingsPage = '/my-page/settings';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case wishlistPage:
      var registryArgument = settings.arguments as RegistryItem;
      return MaterialPageRoute(builder: (context) => WishListPage(registryItem: registryArgument));
    case settingsPage:
      return MaterialPageRoute(builder: (context) => const SettingsPage());
    case wishSettingPage:
      return MaterialPageRoute(builder: (context) => WishSettingPage());
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
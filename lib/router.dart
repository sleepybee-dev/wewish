import 'package:flutter/material.dart';
import 'package:wewish/home.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/page/page_registry.dart';
import 'package:wewish/page/page_settings.dart';


const String home = '/';
const String wishlistPage = '/wishlist';
const String settingsPage = '/mypage/settings';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case wishlistPage:
      var registryArgument = settings.arguments as RegistryItem;
      return MaterialPageRoute(builder: (context) => RegistryPage(registryItem: registryArgument));
    case settingsPage:
      return MaterialPageRoute(builder: (context) => const SettingsPage());
    default:
      return MaterialPageRoute(builder: (context) => Home());
  }
}
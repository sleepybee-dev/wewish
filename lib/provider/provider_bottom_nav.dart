import 'package:flutter/cupertino.dart';

class NavigationProvider extends ChangeNotifier{

  MainTab _curTab = MainTab.home;
  MainTab get currentTab => _curTab;

  updateCurrentTab(MainTab tab, {bool? shouldFocus}) {
    _curTab = tab;
    notifyListeners();
  }
}

enum MainTab {
  search, home, myPage
}

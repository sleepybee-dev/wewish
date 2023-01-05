import 'package:flutter/cupertino.dart';

class NavigationProvider extends ChangeNotifier{
  int _index = 1;
  int get currentPage => _index;

  updateCurrentPage(int index) {
    _index = index;
    notifyListeners();
  }

}
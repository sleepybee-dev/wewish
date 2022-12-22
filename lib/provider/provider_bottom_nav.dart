import 'package:flutter/cupertino.dart';

class BottomNavProvider extends ChangeNotifier{
  int _index = 0;
  int get currentPage => _index;

  updateCurrentPage(int index) {
    _index = index;
    notifyListeners();
  }

}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wewish/page/page_list.dart';
import 'package:wewish/page/page_my.dart';
import 'package:wewish/page/page_search.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late BottomNavProvider _bottomNavProvider;

  @override
  Widget build(BuildContext context) {
    _bottomNavProvider = Provider.of<BottomNavProvider>(context);
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildNavBody(),
    );
  }

  Widget _buildNavBody() {
    switch (_bottomNavProvider.currentPage) {
      case 0:
        return const SearchPage();
      case 1:
        return const ListPage();
      case 2:
        return const MyPage();
    }
    return Container();
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
        const BottomNavigationBarItem(icon: Icon(Icons.list), label: 'list'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'mypage'),
      ],
      currentIndex: _bottomNavProvider.currentPage,
      onTap: (index) {
        _bottomNavProvider.updateCurrentPage(index);
      },
    );
  }
}

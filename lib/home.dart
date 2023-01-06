import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wewish/page/page_home.dart';
import 'package:wewish/page/page_my.dart';
import 'package:wewish/page/page_search.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late NavigationProvider _navigationProvider;

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      bottomNavigationBar: kIsWeb ? null : _buildBottomNavBar(),
      body: Column(
        children: [
          kIsWeb ? _buildTopNavBar() : Container(),
          Expanded(child: _buildNavBody()),
        ],
      ),
    );
  }

  Widget _buildNavBody() {
    switch (_navigationProvider.currentPage) {
      case 0:
        return const SearchPage();
      case 1:
        return const HomePage();
      case 2:
        return const MyPage();
    }
    return Container();
  }

  Widget _buildTopNavBar() {
    return Row(
      children: [
        Text('We Wish', style: TextStyle(fontSize: 32),),
        Expanded(child: Container()),
        IconButton(icon: Icon(Icons.search), onPressed: () => _navigationProvider.updateCurrentPage(0), color: _navigationProvider.currentPage == 0 ? Colors.red : Colors.black,),
        IconButton(icon: Icon(Icons.home), onPressed: () => _navigationProvider.updateCurrentPage(1), color: _navigationProvider.currentPage == 1 ? Colors.red : Colors.black,),
        IconButton(icon: Icon(Icons.person), onPressed: () => _navigationProvider.updateCurrentPage(2), color: _navigationProvider.currentPage == 2 ? Colors.red : Colors.black,),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'mypage'),
      ],
      currentIndex: _navigationProvider.currentPage,
      onTap: (index) {
        _navigationProvider.updateCurrentPage(index);
      },
    );
  }
}

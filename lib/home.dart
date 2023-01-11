import 'dart:io';
import 'dart:math';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wewish/page/page_home.dart';
import 'package:wewish/page/page_my.dart';
import 'package:wewish/page/page_mypage.dart';
import 'package:wewish/page/page_search.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/router.dart' as router;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String METHOD_GET_SHARED_TEXT = "getSharedText";
  final MethodChannel _channel =
      const MethodChannel("com.codeinsongdo.wewish/add-wish");

  @override
  void initState() {
    super.initState();
    getSharedText().then((value) {
      if (value.contains("http")) {
        Navigator.pushNamed(context, router.wishSettingPage, arguments: value);
      }
    });
    getDynamicLink();
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      bottomNavigationBar: kIsWeb ? null : _buildBottomNavBar(),
      body: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Column(
          children: [
            kIsWeb ? _buildTopNavBar() : Container(),
            Expanded(child: _buildNavBody()),
          ],
        ),
      ),
    );
  }

  late NavigationProvider _navigationProvider;
  DateTime? _lastBackPressedTime;

  Widget _buildNavBody() {
    switch (_navigationProvider.currentPage) {
      case 0:
        return const SearchPage();
      case 1:
        return const HomePage();
      case 2:
        return const MyPageTemp();
    }
    return Container();
  }

  Widget _buildTopNavBar() {
    return Row(
      children: [
        Text(
          'We Wish',
          style: TextStyle(fontSize: 32),
        ),
        Expanded(child: Container()),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _navigationProvider.updateCurrentPage(0),
          color:
              _navigationProvider.currentPage == 0 ? Colors.red : Colors.black,
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () => _navigationProvider.updateCurrentPage(1),
          color:
              _navigationProvider.currentPage == 1 ? Colors.red : Colors.black,
        ),
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () => _navigationProvider.updateCurrentPage(2),
          color:
              _navigationProvider.currentPage == 2 ? Colors.red : Colors.black,
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.search), label: 'search'),
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'mypage'),
      ],
      currentIndex: _navigationProvider.currentPage,
      onTap: (index) {
        _navigationProvider.updateCurrentPage(index);
      },
    );
  }

  Future<bool> _onWillPop(BuildContext context) {
    DateTime now = DateTime.now();
    if (_lastBackPressedTime == null ||
        now.difference(_lastBackPressedTime!) > const Duration(seconds: 2)) {
      _lastBackPressedTime = now;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Back 버튼을 한 번 더 누르시면 앱이 종료됩니다.'),
        duration: Duration(seconds: 2),
      ));
      return Future.value(false);
    }
    return Future.value(true);
  }

  void getDynamicLink() async {
    Logger logger = Logger(printer: PrettyPrinter());

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      // String realIlink = initialLink.toString().replaceAll("%3D", "=");
      logger.d(dynamicLinkData.link);
      final params = dynamicLinkData.link.queryParameters;
      final rId = params['rId'];
    }).onError((error) {
      // Handle errors
    });

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      logger.d(deepLink);
    }
  }

  Future<String> getSharedText() async {
    if (Platform.isIOS) {
      return "";
    }
    final String sharedText =
        await _channel.invokeMethod(METHOD_GET_SHARED_TEXT);
    return sharedText;
  }
}

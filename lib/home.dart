import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/page/page_home.dart';
import 'package:wewish/page/page_my.dart';
import 'package:wewish/page/page_mypage.dart';
import 'package:wewish/page/page_search.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/router.dart' as router;

class Home extends StatefulWidget {

  MainTab initialTab = MainTab.home;

  Home({Key? key, this.initialTab = MainTab.home}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String METHOD_GET_SHARED_TEXT = "getSharedText";
  final MethodChannel _channel =
      const MethodChannel("com.codeinsongdo.wewish/add-wish");

  late NavigationProvider _navigationProvider;
  DateTime? _lastBackPressedTime;
  bool _onLoadingDynamicLinkData = false;

  @override
  void initState() {
    super.initState();
    getSharedText().then((value) {
      if (value.contains("http")) {
        Navigator.pushNamed(context, router.wishEditPage, arguments: value);
      }
    });
    getDynamicLink();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigationProvider = context.watch<NavigationProvider>();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: kIsWeb ? null : _buildBottomNavBar(),
      body: WillPopScope(
          onWillPop: () => _onWillPop(context), child: _onLoadingDynamicLinkData ? _buildProgressCircle() : _buildBody()),
    );
  }


  Widget _buildNavBody() {
    switch (_navigationProvider.currentTab) {
      case MainTab.search:
        return const SearchPage();
      case MainTab.home:
        return const HomePage();
      case MainTab.myPage:
        return const MyPageTemp();
    }
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
          onPressed: () => _navigationProvider.updateCurrentTab(MainTab.search),
          color:
              _navigationProvider.currentTab == MainTab.search ? Theme.of(context).primaryColor : Colors.black12,
        ),
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () => _navigationProvider.updateCurrentTab(MainTab.home),
          color:
              _navigationProvider.currentTab == MainTab.home ? Theme.of(context).primaryColor : Colors.black12,
        ),
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () => _navigationProvider.updateCurrentTab(MainTab.myPage),
          color:
              _navigationProvider.currentTab == MainTab.myPage ? Theme.of(context).primaryColor : Colors.black12,
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey.withOpacity(0.5),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 32,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.search), label: 'search'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'mypage'),
      ],
      currentIndex: _navigationProvider.currentTab.index,
      onTap: (index) {
        _navigationProvider.updateCurrentTab(MainTab.values[index]);
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
      _goToDeepLink(dynamicLinkData);
    }).onError((error) {
      setState(() {
        _onLoadingDynamicLinkData = false;
      });
    });

    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      logger.d(deepLink);
      _goToDeepLink(initialLink);
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

  Widget _buildBody() {
    return Column(
      children: [
        kIsWeb ? _buildTopNavBar() : Container(),
        Expanded(child: _buildNavBody()),
      ],
    );
  }

  Future<RegistryItem?> _fetchRegistryByRId(String rId) async {
    DocumentSnapshot<RegistryItem> snapshot = await FirebaseFirestore.instance
        .collection('registry')
        .withConverter<RegistryItem>(
          fromFirestore: (snapshots, _) =>
              RegistryItem.fromJson(snapshots.data()!),
          toFirestore: (registry, _) => registry.toJson(),
        )
        .doc(rId)
        .get();

    return snapshot.data();
  }

  void _goWishListPage(RegistryItem registryItem) {
    Navigator.pushNamed(context, router.wishlistPage, arguments: registryItem);
  }

  Widget _buildProgressCircle() {
    return Center(child: CircularProgressIndicator(),);
  }

  void _goToDeepLink(PendingDynamicLinkData dynamicLinkData) {
    final params = dynamicLinkData.link.queryParameters;
    final rId = params['rId'];
    setState(() {
      _onLoadingDynamicLinkData = true;
    });
    if (rId != null) {
      _fetchRegistryByRId(rId).then((registryItem) {
        setState(() {
          _onLoadingDynamicLinkData = false;
        });
        if (registryItem != null) {
          _goWishListPage(registryItem);
        }
      });
    } else {
      setState(() {
        _onLoadingDynamicLinkData = false;
      });
    }
  }
}

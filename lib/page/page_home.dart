import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/router.dart' as router;



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String METHOD_GET_SHARED_TEXT = "getSharedText";
  final MethodChannel _channel = MethodChannel("com.codeinsongdo.wewish/add-wish");

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
    return SafeArea(child: Center(
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('이름을 검색하여\n다른 사람들의 위시리스트를\n확인 할 수 있어요\n\n', textAlign: TextAlign.center, style:TextStyle(fontSize: 40)),
            GestureDetector(
                onTap: () => goSearchPage(),
                child: Container(
                  height: 50,
                  decoration : BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.3),
                    blurRadius: 5, offset: const Offset(0,3),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.white,
                  ),
                ),
            ),
        ],
        ),
      ),
    ));
  }

  Future<String> getSharedText() async {
    if (Platform.isIOS) {
      return "";
    }
    final String sharedText = await _channel.invokeMethod(METHOD_GET_SHARED_TEXT);
    return sharedText;
  }

  goSearchPage() {
    Provider.of<NavigationProvider>(context, listen: false).updateCurrentPage(0);
  }

  void getDynamicLink() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final initialLink = data?.link;

    String realIlink = initialLink.toString().replaceAll("%3D", "=");
    String firstEdit = realIlink.split('/').last;

  }

}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/router.dart' as router;
import 'package:wewish/ui/textfield_search.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('이름을 검색하여\n위시리스트를 볼 수 있어요', textAlign: TextAlign.center,),
            GestureDetector(
                onTap: () => goSearchPage(),
                child: SearchTextField(
                  enabled: false,
                  onPressed: (){},)),
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

}

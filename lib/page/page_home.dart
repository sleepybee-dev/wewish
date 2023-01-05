import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container());
  }

  Future<String> getSharedText() async {
    if (Platform.isIOS) {
      return "";
    }
    final String sharedText = await _channel.invokeMethod(METHOD_GET_SHARED_TEXT);
    return sharedText;
  }

}

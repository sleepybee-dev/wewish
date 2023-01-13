import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/page/page_mypage_login.dart';
import 'package:wewish/page/page_my.dart';
import 'package:wewish/router.dart' as router;

class MyPageTemp extends StatefulWidget {
  const MyPageTemp({Key? key}) : super(key: key);

  @override
  State<MyPageTemp> createState() => _MyPageTempState();
}

class _MyPageTempState extends State<MyPageTemp> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot);
            if (!snapshot.hasData) {
              return MypageLogin();
            } else {
              return MyPage(user:snapshot.data as User);
            }
          },
        ),
      ),
    );
  }

}

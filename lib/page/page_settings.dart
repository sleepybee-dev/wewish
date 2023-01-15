import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wewish/page/page_edit_profile.dart';
import 'package:wewish/page/page_home.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const String _title = '설정';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfile()),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50), //버튼크기 지정
          // side: BorderSide(color: Colors.black87, width: 2.0)
        ),
        child: const Text('프로필 수정'),
      ),
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50), //버튼크기 지정
          // side: BorderSide(color: Colors.black87, width: 2.0)
        ),
        child: const Text('알림 설정'),
      ),
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50), //버튼크기 지정
          // side: BorderSide(color: Colors.black87, width: 2.0)
        ),
        child: const Text('개인정보 처리 방침'),
      ),
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50), //버튼크기 지정
          // side: BorderSide(color: Colors.black87, width: 2.0)
        ),
        child: const Text('회원 탈퇴'),
      ),
      OutlinedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50), //버튼크기 지정
          // side: BorderSide(color: Colors.black87, width: 2.0)
        ),
        child: const Text('로그아웃'),
      ),
    ]));
  }
}



























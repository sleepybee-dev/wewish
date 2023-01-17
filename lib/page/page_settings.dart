import 'package:flutter/material.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/kakao_login_test.dart';
import 'package:wewish/viewmodel/viewmodel_social_login.dart';
import 'package:wewish/page/page_edit_profile.dart';

class SettingsPage extends StatelessWidget {
  UserItem userItem;

  SettingsPage({Key? key, required this.userItem}) : super(key: key);

  static const String _title = '설정';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: MyStatelessWidget(
        userItem: userItem,
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  UserItem userItem;

  MyStatelessWidget({Key? key, required this.userItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(
                          userItem: userItem,
                        )),
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
              final viewModel = SocialLoginViewModel(KakaoLogin());
              viewModel.logout().then((value) {
                Navigator.pop(context);
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50), //버튼크기 지정
              // side: BorderSide(color: Colors.black87, width: 2.0)
            ),
            child: const Text('로그아웃'),
          ),
        ]);
  }
}

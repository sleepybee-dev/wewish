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
          _buildSettingButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditProfile(
                          userItem: userItem,
                        )),
              );
            },
            label: '프로필 수정',
          ),
          _buildSettingButton(
            onPressed: () {},
            label: '알림 설정',
          ),
          _buildSettingButton(
            onPressed: () {},
            label: '개인정보 처리 방침',
          ),
          _buildSettingButton(
            onPressed: () {},
            label: '회원 탈퇴',
          ),
          _buildSettingButton(
            onPressed: () {
              final viewModel = SocialLoginViewModel(KakaoLogin());
              viewModel.logout().then((value) {
                Navigator.pop(context);
              });
            },
            label: '로그아웃',
          ),
        ]);
  }

  Widget _buildSettingButton(
      {required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        height: 56,
        child: Padding(
          padding: const EdgeInsets.only(left:20.0),
          child: Text(label, textAlign: TextAlign.left, style: TextStyle(fontSize: 16),),
        ),
        ),
    );
  }
}

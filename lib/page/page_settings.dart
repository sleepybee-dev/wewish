import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wewish/constants.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/kakao_login_test.dart';
import 'package:wewish/ui/body_common.dart';
import 'package:wewish/viewmodel/viewmodel_social_login.dart';
import 'package:wewish/page/page_edit_profile.dart';

class SettingsPage extends StatelessWidget {
  UserItem userItem;

  SettingsPage({Key? key, required this.userItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return CommonBody(
      showBackButton: true,
      onBackPressed: () => Navigator.of(context).pop(),
      title: '설정',
      child: Column(
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
            // _buildSettingButton(
            //   onPressed: () {},
            //   label: '알림 설정',
            // ),
            _buildSettingButton(
              onPressed: () => _launchUrl(privacyPolicyUrl),
              label: '개인정보 처리 방침',
            ),
            _buildSettingButton(
              onPressed: () => _sendMail(context),
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
          ]),
    );
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
          child: Text(label, textAlign: TextAlign.left, style: const TextStyle(fontSize: 16),),
        ),
        ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  _sendMail(BuildContext context) async {
    final Email email = Email(
      body: '계정 : ${userItem.email}\n닉네임 : ${userItem.nickname}\n회원 탈퇴 및 계정 정보 삭제에 동의합니다.',
      subject: '[회원탈퇴요청]',
      recipients: ['sleepybee410@gmail.com'],
      isHTML: false,
    );

    FlutterEmailSender.send(email).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('회원탈퇴 접수하셨다면 처리 후 해당 계정으로 회신 드리겠습니다.')));
    });
  }
}

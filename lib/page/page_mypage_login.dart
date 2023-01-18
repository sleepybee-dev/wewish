import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/kakao_login_test.dart';
import 'package:wewish/ui/body_common.dart';
import 'package:wewish/viewmodel/viewmodel_social_login.dart';
import 'package:wewish/page/page_settings.dart';

import 'package:wewish/router.dart' as router;

class MyPageLogin extends StatefulWidget {
  const MyPageLogin({Key? key}) : super(key: key);

  @override
  State<MyPageLogin> createState() => _MyPageLoginState();
}

class _MyPageLoginState extends State<MyPageLogin> {
  final viewModel = SocialLoginViewModel(KakaoLogin());
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CommonBody(
      child: Center(
        child: Stack(children: [
          _isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('로그인하여\n나만의 위시리스트를\n만들어 주세요',
                    style: Theme.of(context).textTheme.headlineMedium),
                // Container(height: 150, child: Text('photo')),
                _buildKakaoLoginButton(),
                Platform.isIOS ? _buildAppleLoginButton() : Container(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildAppleLoginButton() {
    return SizedBox(
      height: 56,
      child: SignInButton(
        Buttons.apple,
        text: 'Sign up with Apple',
        onPressed: signInWithApple,
      ),
    );
  }

  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Widget _buildKakaoLoginButton() {
    return SizedBox(
      height: 56,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isLoading = true;
          });
          viewModel.login().then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        },
        child: const Image(
          image: AssetImage(
              'assets/images/kakao_login_large_wide.png'), fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

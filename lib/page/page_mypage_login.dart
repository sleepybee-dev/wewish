import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/page/page_settings.dart';

import 'package:wewish/router.dart' as router;

class MypageLogin extends StatefulWidget {
  const MypageLogin({Key? key}) : super(key: key);

  @override
  State<MypageLogin> createState() => _MypageLoginState();
}

class _MypageLoginState extends State<MypageLogin> {

  // Future<UserCredential> signInWithGoogle() async {
  // 구글 로그인
  // Trigger the authentication flow
  // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  // // Obtain the auth details from the request
  // final GoogleSignInAuthentication? googleAuth =
  // await googleUser?.authentication;
  //
  // // Create a new credential
  // final credential = GoogleAuthProvider.credential(
  //   accessToken: googleAuth?.accessToken,
  //   idToken: googleAuth?.idToken,
  // );

  // Once signed in, return the UserCredential
  // return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: TextButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            }, child: Text('설정')),
          ),
          SizedBox(height: 100),
          Column(
            children: [

              Text('로그인하여',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              Text('나만의 위시리스트를',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
              Text('만들어 주세요',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 50),
          Container(height: 180, child: Text('photo')),

          Column(
            children: [

              Container(
                width: 220,
                child: OutlinedButton(
                  onPressed: () => {},
                  child: Text(
                    '이메일로 회원가입하기',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFFE0E0E0)),
                ),
              ),
              Container(
                width: 220,
                child: OutlinedButton(
                  onPressed: () => {},
                  child: Text(
                    '카카오 로그인',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xfffee500)),
                ),
              ),
              Container(
                width: 220,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    '구글 로그인',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xffffffff)),
                ),
              ),
              Platform.isIOS ? _buildAppleLoginButton() : Container()
            ],
          ),
        ],
      ),

    );
  }

  Widget _buildAppleLoginButton() {
    return SignInButton(
      Buttons.apple,
      text: 'Sign up with Apple',
      onPressed: signInWithApple,
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

}

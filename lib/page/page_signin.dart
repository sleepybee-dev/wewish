import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wewish/router.dart' as router;

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const String _title = '로그인';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MySignInPage(),
      ),
    );
  }
}

class MySignInPage extends StatefulWidget {
  const MySignInPage({Key? key}) : super(key: key);

  @override
  State<MySignInPage> createState() => _MySignInPageState();
}

class _MySignInPageState extends State<MySignInPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void _goWishListPage() {
    Navigator.pushNamed(context, router.wishlistPage);
  }

  void _signIn(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 12.0,
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
        SizedBox(
          width: 300,
          height: 50,
          child: TextFormField(
            onChanged: (text) {
              if (label == "password") {
                this.password = text;
              }
              if (label == "email") {
                this.email = text;
              }
            },
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(5),
                )),
                hintText: label,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                )),
            onSaved: onSaved,
            validator: validator,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text('Wewish로 '),
          Text('선물을 함께하세요!'),
          SizedBox(height: 20),
          Form(
              key: this.formKey,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      renderTextFormField(
                        label: 'email',
                        onSaved: (val) {
                          setState(() {
                            this.email = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '이메일은 필수사항입니다.';
                          }
                          if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(val)) {
                            return '잘못된 이메일 형식입니다.';
                          }

                          return null;
                        },
                      ),
                      renderTextFormField(
                        label: 'password',
                        onSaved: (val) {
                          setState(() {
                            this.password = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '비밀번호는 필수사항입니다.';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                          height: 40,
                          width: 300,
                          child: ElevatedButton(
                              onPressed: () {
                                if (this.formKey.currentState!.validate()) {
                                  this.formKey.currentState!.save();
                                  _signIn(this.email, this.password);
                                  print(FirebaseAuth.instance.currentUser);
                                }
                              },
                              child: Text('로그인'))),
                    ],
                  ))),
        ],
      ),
    );
  }
}

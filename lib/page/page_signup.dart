import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wewish/router.dart' as router;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String _title = '회원가입';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _signup = false;

  @override
  Widget build(BuildContext context) {
    if (_signup == true) {}
    return MaterialApp(
      title: SignUpPage._title,
      home: Scaffold(
        appBar: AppBar(title: const Text(SignUpPage._title)),
        body: const MySignUpPage(),
      ),
    );
  }
}

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({Key? key}) : super(key: key);

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void _goWishListPage() {
    Navigator.pushNamed(context, router.wishlistPage);
  }

  void _signUp(email, password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
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
  String name = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';

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
        Column(
          children: [
            // Text(
            //   label,
            //   style: TextStyle(
            //     fontSize: 12.0,
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
          ],
        ),
        SizedBox(
          width: 300,
          height: 50,
          child: TextFormField(
            onChanged: (text) {
              if (label == "password") {
                this.password = text;
              }
              if (label == 'password confirm') {
                this.passwordConfirm = text;
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
          Text('Wewish와 '),
          Text('시작하는 따뜻한 마음'),
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
                        label: 'name',
                        onSaved: (val) {
                          setState(() {
                            this.name = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '이름은 필수사항입니다.';
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

                          if (val.length < 8) {
                            return '8자 이상 입력해주세요!';
                          }
                          return null;
                        },
                      ),
                      renderTextFormField(
                        label: 'password confirm',
                        onSaved: (val) {},
                        validator: (val) {
                          if (this.password != this.passwordConfirm) {
                            return '비밀번호가 일치하지 않습니다.';
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
                                  _signUp(this.email, this.password);
                                }
                              },
                              child: Text('회원가입 하기'))),
                    ],
                  ))),
        ],
      ),
    );
  }
}

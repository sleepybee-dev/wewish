import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


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
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>EditProfile()),
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
                onPressed: () {
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50), //버튼크기 지정
                  // side: BorderSide(color: Colors.black87, width: 2.0)
                ),
                child: const Text('알림 설정'),

              ),

              OutlinedButton(
                onPressed: () {

                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50), //버튼크기 지정
                  // side: BorderSide(color: Colors.black87, width: 2.0)
                ),
                child: const Text('개인정보 처리 방침'),
              ),
              OutlinedButton(
                onPressed: () {

                },

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
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50), //버튼크기 지정
                  // side: BorderSide(color: Colors.black87, width: 2.0)
                ),
                child: const Text('로그아웃'),
              ),

            ]
        )
    );
  }
}
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

final storageRef = FirebaseStorage.instance.ref();
final imagesRef = storageRef.child('profile');
final spaceRef = storageRef.child('profile/default.jpg');

class _EditProfileState extends State<EditProfile> {
  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('프로필 수정')),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView(
              children: <Widget>[
                imageProfile(),
                SizedBox(height: 20),
                nameTextField(),
                SizedBox(height: 20),
                idField(),
                SizedBox(height: 20),
                hashtagField(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Respond to button press
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50)),

                  child: Text("변경 사항 저장"),
                )


              ],


            )
        )
    );
  }


  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/profile%2Fdefault.jpg?alt=media&token=a3a5f0b3-9322-428e-a235-1ed97487e911'), //기본이미지(true)
//가져온이미지(false)
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  takePhoto(ImageSource.gallery);
                },

                child: Icon(
                  Icons.add,
                  color: Colors.black38,
                  size: 40,
                ),
              )
          )
        ],
      ),
    );
  }

  Widget nameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        labelText: '닉네임',
      ),
    );
  }

  Widget idField() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        labelText: '아이디',
      ),
    );
  }

  Widget hashtagField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          labelText: '해시태그',
          hintText: '상태메세지를 입력해주세요.'
      ),
    );
  }

  takePhoto(ImageSource source) async{
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile as PickedFile;
    });

  }

}



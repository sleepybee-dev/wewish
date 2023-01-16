import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:wewish/model/item_user.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  UserItem? userItem;

  EditProfile({Key? key, this.userItem}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.userItem != null) {
      _nameController.text = widget.userItem!.nickname;
    }
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadPic(context as BuildContext);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadPic(BuildContext context) async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

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
                Text('*닉네임',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                nameField(),
                SizedBox(height: 20),
                Text('*해시태그',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                hashtagField(),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("변경 사항 저장"),
                  onPressed: () {
                    uploadPic(context); // Respond to button press
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50)),
                )
              ],
            )));
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.transparent,
            child: _photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      _photo!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                : Image.network(
                    widget.userItem != null
                        ? widget.userItem!.profileUrl
                        : 'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/profile%2Fdefault.jpg?alt=media&token=a3a5f0b3-9322-428e-a235-1ed97487e911',
                    fit: BoxFit.fill,
                  ),
            //기본이미지(true)
//가져온이미지(false)
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  imgFromGallery();
                  Navigator.of(context as BuildContext).pop();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black38,
                  size: 40,
                ),
              ))
        ],
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightBlue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightBlue,
            width: 1.0,
          ),
        ),
      ),
    );
  }

  Widget hashtagField() {
    return TextFieldTags(
      textSeparators: const [' ', ','],
      tagsStyler: TagsStyler(
          tagTextStyle:
              TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          tagDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.blue)),
          tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.black),
          tagPadding: const EdgeInsets.all(6.0)),
      onTag: (tag) {
        print(tag);
      },
      onDelete: (tag) {},
      textFieldStyler: TextFieldStyler(
        textFieldEnabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
        ),
        helperText: '최대 10자 이내로 타이핑 후 ,를 입력해주세요',
        hintText: '상태메세지를 입력해주세요.',
        helperStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

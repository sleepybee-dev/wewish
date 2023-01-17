import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:wewish/constants.dart';
import 'package:wewish/model/item_user.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  UserItem userItem;

  EditProfile({Key? key, required this.userItem}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextFieldTagsController _hashTagController = TextFieldTagsController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userItem.nickname;
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
        maxWidth: 320,
        maxHeight: 320,
        imageQuality: 50,
        source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> uploadPic(File selectedPhoto) async {
    final fileName = widget.userItem.uId! + DateTime.now().toIso8601String() + basename(selectedPhoto.path).replaceAll('scaled_image_picker', '');
    final destination = 'profile/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination);

      firebase_storage.TaskSnapshot snapshot = await ref.putFile(selectedPhoto);
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('프로필 수정')),
        body: Stack(children: [
          _isLoading ? Center(child: CircularProgressIndicator()) : Container(),
          Padding(
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
                    onPressed: () => _doUpdateProfile(context),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(400, 50)),
                  )
                ],
              ))
        ]));
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
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.network(
                    widget.userItem.profileUrl ?? defaultProfileUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  pickImageFromGallery();
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
      onEditingComplete: () {
        widget.userItem.nickname = _nameController.text;
      },
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
      textFieldTagsController: _hashTagController,
      initialTags: widget.userItem.hashTag,
      textSeparators: const [' ', ','],
      tagsStyler: TagsStyler(
          showHashtag: true,
          tagTextStyle:
              TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
          tagDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.blue)),
          tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.black),
          tagPadding: const EdgeInsets.all(6.0)),
      onTag: (tag) {
        widget.userItem.hashTag.add(tag);
      },
      onDelete: (tag) {
        widget.userItem.hashTag.remove(tag);
      },
      textFieldStyler: TextFieldStyler(
        textFieldEnabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
        ),
        helperText: '자신을 알아볼 수 있는 태그를 3개 이상 입력해 주세요.',
        hintText: '(예)#제주도토박이 #뿌링클처돌이 #도시어부',
        helperStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hashTagController.dispose();
    super.dispose();
  }

  Future<void> updateUser() async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.userItem.uId!)
        .set(widget.userItem.toJson());
  }

  _doUpdateProfile(BuildContext context) async {
      setState(() {
        _isLoading = true;
      });
      if (_isValidUserData()) {
        if (widget.userItem.profileUrl != null) {
          // 원래 프사 안 바꿈
        } else {
          if (_photo == null) {
            // 원래 프사 없는데 프사 선택 안함. 기본형으로 그냥 넣을까 고민중.
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('프로필 사진을 선택해 주세요.')));
          } else {
            final profileUrl = await uploadPic(_photo!);
            if (profileUrl != null) {
              widget.userItem.profileUrl = profileUrl;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('사진 업로드 중 오류가 발생했어요.')));
            }
          }
        }
        updateUser().then((value) {
          Navigator.of(context).pop();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('입력란을 채워주세요.')));
      }
      setState(() {
        _isLoading = false;
      });

  }

  bool _isValidUserData() {
    return widget.userItem.nickname.length >= 2 && widget.userItem.hashTag.length >= 3;
  }
}

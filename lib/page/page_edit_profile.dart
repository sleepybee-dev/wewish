import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:wewish/model/item_user.dart';

class EditProfile extends StatefulWidget {
  UserItem? userItem;

  EditProfile({Key? key, this.userItem}) : super(key: key);

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
                Text('*이메일', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                emailTextField(),
                SizedBox(height: 20),
                Text('*아이디', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                idField(),
                SizedBox(height: 20),
                Text('*해시태그', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                hashtagField(),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("변경 사항 저장"),
                  onPressed: () {
                    // Respond to button press
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(400, 50)),
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
              backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/wewish-b573a.appspot.com/o/profile%2Fdefault.jpg?alt=media&token=a3a5f0b3-9322-428e-a235-1ed97487e911') //기본이미지(true)
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
              ))
        ],
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
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

  Widget idField() {
    return TextFormField(
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
    return Column(
        children: [
          TextFieldTags(
            textSeparators: const [' ', ','],
            tagsStyler: TagsStyler(
                tagTextStyle: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black),
                tagDecoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.blue)),
                tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.black),
                tagPadding: const EdgeInsets.all(6.0)
            ),
            onTag: (tag) {
              print(tag);
            },
            onDelete: (tag) {},
            textFieldStyler: TextFieldStyler(

              textFieldEnabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue, width: 1.0
                ),
              ),
              helperText: '최대 10자 이내로 타이핑 후 ,를 입력해주세요',
              hintText: '상태메세지를 입력해주세요.',
              helperStyle: const TextStyle(color: Colors.grey),
            ),
          ),


        ]
    );

  }

  takePhoto(ImageSource source) async{
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile as PickedFile;
    });

  }
}

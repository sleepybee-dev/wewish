import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/page/page_my_givelist.dart';
import 'package:wewish/page/page_my_wishlist.dart';
import 'package:wewish/router.dart' as router;
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPage extends StatefulWidget {
  User? user;

  MyPage({Key? key, this.user}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class UserTemp {
  String profileUrl;
  String nickname;

  UserTemp({
    required this.profileUrl,
    required this.nickname,
  });
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final firestore = FirebaseFirestore.instance;

  List<UserTemp> user_datas = [
    // User(profileUrl: profileUrl, nickname: nickname, hashtag: hashtag)
  ];
  List user_hashtag = [];

  void setUser(profileUrl, nickname) {
    user_datas.add(UserTemp(profileUrl: profileUrl, nickname: nickname));
  }

  // TODO widget.user의 uid를 가지고 user와 registry 가져오기
  Future<List> getUser() async {
    var result = await firestore.collection('registry').get();
    result.docs.forEach((e) {
      // registry 내부 문서를 돈다.
      // print(e.data()); // registry 내부 문서 id 순
      if (e.data()['user']['nickname'] == '홍길동') {
        user_hashtag.add(e.data()['user']['hashtag']);
        e.data().forEach((key, value) {
          if (key == 'user') {
            // print(e.data()['user']);
            // print('user hello');
            // print(e['hashtag']);
            setUser(
                e.data()['user']['profileUrl'], e.data()['user']['nickname']);

            // value.forEach((e) {
            //
            //   // print(e['profileUrl']);
            //   // print(e['nickname']);
            //   // print(e['hashtag']);
            //   // setUser(e['profileUrl'], e['nickname'], e['hashtag']);
            // });
          }
        });
      }
    });
    return user_datas;
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    if (widget.user != null) {
      final loginUser = widget.user!;
      // 파이어스토어에 저장된 user가 있는지 확인
      _fetchFirebaseUserByUId(loginUser.uid).then((userItem) {
        if (userItem == null) {
          // 없으면 프로필 세팅으로
          UserItem newUser = UserItem()
            ..uId = loginUser.uid
            ..nickname = loginUser.displayName ?? ''
            ..joinDate = DateTime.now()
            ..lastVisitDate = DateTime.now()
            ..email = loginUser.email ?? '';
          _goProfileSettingPage(newUser);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _goAddPage(),
        ),
        body: Stack(alignment: Alignment.topRight, children: [
          TextButton(onPressed: _goSettingPage, child: Text('설정')),
          Column(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getUser(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData == false) {
                        return Text('loading');
                      } else {
                        return Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 80,
                              width: 80,
                              child:
                                  Image.network('${user_datas[0].profileUrl}'),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Column(
                                children: [
                                  Text(
                                    user_datas[0].nickname,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Row(
                                    children: [
                                      Text('Hashtag : '),
                                      for (var i in user_hashtag[0])
                                        Text(i.toString() + ' ')
                                    ],
                                    // children: [
                                    //   Text('Hash Tag'),
                                    //   user_hashtag[0]!.forEach((element) {
                                    //     element != null
                                    //         ? Text(element)
                                    //         : Text('end');
                                    //   })
                                    // ],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    },
                  )),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: TabBar(
                  tabs: [
                    Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text("위시리스트",
                            style: TextStyle(color: Colors.black))),
                    Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text("준 선물리스트",
                            style: TextStyle(color: Colors.black)))
                  ],
                  unselectedLabelColor: Colors.black,
                  controller: _tabController,
                ),
              ),
              Expanded(
                  child: TabBarView(controller: _tabController, children: [
                Container(
                  alignment: Alignment.center,
                  child: WishList(),
                ),
                Container(
                  alignment: Alignment.center,
                  child: GiveList(),
                ),
              ]))
            ],
          ),
        ]),
      ),
    );
  }

  _goAddPage() {
    Navigator.pushNamed(context, router.wishEditPage);
  }

  void _goSettingPage() {
    Navigator.pushNamed(context, router.settingsPage);
  }

  Future<UserItem?> _fetchFirebaseUserByUId(String uId) async {
    QuerySnapshot<UserItem> snapshot = await FirebaseFirestore.instance
        .collection('user').where('uId', isEqualTo: uId)
        .withConverter<UserItem>(
      fromFirestore: (snapshots, _) =>
          UserItem.fromJson(snapshots.data()!),
      toFirestore: (user, _) => user.toJson(),
    ).get();
    if (snapshot.docs.isEmpty) {
      return null;
    } else {
      return snapshot.docs[0].data();
    }
  }

  void _goProfileSettingPage(UserItem userItem) {
    Navigator.pushNamed(context, router.profileEditPage, arguments: userItem).then((value) {
      setState(() {

      });
    });
  }

}

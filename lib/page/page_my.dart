import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/page/page_my_actionlist.dart';
import 'package:wewish/page/page_my_wishlist.dart';
import 'package:wewish/page/page_settings.dart';
import 'package:wewish/provider/provider_user.dart';
import 'package:wewish/router.dart' as router;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wewish/ui/body_common.dart';
import 'package:wewish/ui/card_profile.dart';

class MyPage extends StatefulWidget {
  User user;

  MyPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  
  late TabController _tabController;
  final firestore = FirebaseFirestore.instance;
  UserItem? _curUser;
  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.watch();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    final loginUser = widget.user;
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
      } else {
        // 저장된 user가 있다면 그 값으로 마이페이지 출력
        _curUser = userItem;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
          onPressed: () => _goAddPage(),
        ),
        body: _curUser != null
            ? _buildBody(_curUser!)
            :
            // _curUser를 initState에서 체크함에도 불구하고 null인 경우가 있음. (신규가입 후 프로필 저장 후 돌아왔을때)
            FutureBuilder<UserItem?>(
                future: _fetchUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(
                      child: Text('문제가 발생했어요'),
                    );
                  }
                  final userItem = snapshot.data!;
                  _userProvider.updateLoginUser(userItem);
                  return _buildBody(userItem);
                }),
      ),
    );
  }

  _goAddPage() {
    Navigator.pushNamed(context, router.wishEditPage);
  }

  void _goSettingPage() {
    Navigator.pushNamed(context, router.settingsPage, arguments: _curUser);
  }

  Future<UserItem?> _fetchFirebaseUserByUId(String uId) async {
    DocumentSnapshot<UserItem> snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .withConverter<UserItem>(
          fromFirestore: (snapshots, _) => UserItem.fromJson(snapshots.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();
    if (snapshot.exists) {
      return snapshot.data();
    } else {
      return null;
    }
  }

  void _goProfileSettingPage(UserItem userItem) {
    Navigator.pushNamed(context, router.profileEditPage, arguments: userItem)
        .then((value) {
      setState(() {
        // Edit Profile에서 저장된 값을 다시 불러와야 함.
      });
    });
  }

  Widget _buildBody(UserItem userItem) {
    _userProvider.updateLoginUser(userItem);
    return CommonBody(
      title: '마이페이지',
      rightButton: IconButton(onPressed: _goSettingPage, icon: const Icon(Icons.settings)),
      child: Column(
        children: [
          ProfileCard(userItem),
          SizedBox(
            height: 50,
            child: TabBar(
              tabs: [
                const Text("내 위시", style: TextStyle(color: Colors.black)),
                const Text("보낸 선물", style: TextStyle(color: Colors.black))
              ],
              unselectedLabelColor: Colors.black,
              controller: _tabController,
            ),
          ),
          FutureBuilder<RegistryItem?>(
              future: _fetchRegistry(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('문제가 발생했어요'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('나의 위시를 추가해 보세요'),
                  );
                }
                final RegistryItem registryItem = snapshot.data!;

                return Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    Container(
                      alignment: Alignment.center,
                      child: MyWishList(registryItem.wishList,
                          registryId: registryItem.registryId!),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ActionList(registryItem.actions, currentUser:_curUser!),
                    ),
                  ]),
                );
              })
        ],
      ),
    );
  }

  Future<UserItem?> _fetchUser() async {
    var snapshot = await firestore
        .collection('user')
        .doc(widget.user.uid)
        .withConverter<UserItem>(
          fromFirestore: (snapshots, _) => UserItem.fromJson(snapshots.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();

    return snapshot.data();
  }

  // 마이페이지 최초 접근 시 registry와 user를 둘다 불러오는 것에 대해 고민이 됩니다.
  // 일단 FM으로 user와 registry다 불러오고 user값이 있으면 registry만 불러오는 식으로..

  Future<RegistryItem?> _fetchRegistry() async {
    var snapshot = await firestore
        .collection('registry')
        .where('user.uId', isEqualTo: widget.user.uid)
        .withConverter<RegistryItem>(
          fromFirestore: (snapshots, _) =>
              RegistryItem.fromJson(snapshots.data()!),
          toFirestore: (registry, _) => registry.toJson(),
        )
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    RegistryItem registryItem = snapshot.docs[0].data();
    registryItem.registryId = snapshot.docs[0].id;

    return registryItem;
  }
}

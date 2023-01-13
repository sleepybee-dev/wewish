import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/page/page_wish_reservation.dart';

import '../provider/provider_reservation.dart';
import '../util/meta_parser.dart';


class WishListPage extends StatefulWidget {
  final RegistryItem registryItem;

  const WishListPage({Key? key, required this.registryItem}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final registryCollection = FirebaseFirestore.instance.collection('registry');
  String? curRegistryId;

  Future<RegistryItem> fetchRegistry() async {
    QuerySnapshot<RegistryItem>? snapshot = await registryCollection
        .withConverter<RegistryItem>(
      fromFirestore: (snapshots, _) =>
          RegistryItem.fromJson(snapshots.data()!),
      toFirestore: (registry, _) => registry.toJson(),
    )
        .limit(1)
        .get();

    curRegistryId = snapshot.docs[0].id;
    // 레지스트리 아이템 리스트 중에 첫번째것의 인스턴스를 리턴?
    // 현재 레지스트리를 가리키도록 수정 필요
    RegistryItem registryItem = snapshot.docs.map((e) => e.data()).toList()[0];
    registryItem.registryId = curRegistryId;

    return registryItem;
  }

    bool user = true; // 로그인 여부 판단을 위한 임시 변수
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('위시리스트',)),
        body: Column(
          children: [
            _buildUserProfile(widget.registryItem.user),
            Expanded(child: _buildWishList(widget.registryItem.wishList)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(UserItem user) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundColor: Colors.amberAccent,
              backgroundImage: NetworkImage(user.profileUrl),
              radius: 18.0,
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user.nickname),
                      Text("("+"id"+")"), // firebase에서 가져올 것
                    ],
                  ),
                  Row(
                    children: [
                      Text("#"+user.hashTag[0], style: TextStyle(fontSize: 13,)),
                      Text("#"+user.hashTag[1], style: TextStyle(fontSize: 13,)),
                      Text("#"+user.hashTag[2], style: TextStyle(fontSize: 13,))
                    ],
                  ),

                ],
              ))
        ],
      ),
    );
  }

  Widget _buildWishList(List<WishItem> wishList) {
    return ListView.builder(
        itemCount: wishList.length,
        itemBuilder: (context, index) => _buildWishTile(wishList[index], index));
  }

  Widget _buildWishTile(WishItem wishItem, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _launchUrl(wishItem.url),
        child: Card(
          child: Column(
            children: [
              Container(
                color: Color(0xff97d2f8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(wishItem.name)),
                      Text(wishItem.price.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              FutureBuilder<OpengraphData>(
                  future: _fetchOpengraphData(wishItem.url),
                  builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || (snapshot.connectionState == ConnectionState.done && snapshot.data == null)) {
                  return Container(height: 120, color: Colors.grey,);
                }
                return _buildOpenGraphBox(snapshot.data!, index);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpenGraphBox(OpengraphData opengraphData, int index) {
    return Column(
      children: [
        SizedBox(
          height: 100,
            child: Image.network(opengraphData.image, fit: BoxFit.cover,)),
        Text(opengraphData.title, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
        Text(opengraphData.description),
        Text(opengraphData.url, style: TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis,),
        FutureBuilder<RegistryItem>(
          future: fetchRegistry(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            RegistryItem registryItem = snapshot.data;
            return ButtonBar(
              alignment: MainAxisAlignment.end,
              buttonPadding: EdgeInsets.only(left: 20),
              children: [
                // 임시 로그인/로그아웃을 위한 버튼
                TextButton(
                    onPressed: (){
                      setState(() {
                        user = !user;
                      });
                    },
                    child:
                    Text(user == true ? "임시로그아웃" : "임시로그인",style: TextStyle(color: Colors.deepOrange)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (user == true){
                      // 필요 기능: 파베 상태 변경, 예약확인 알림창 또는 스낵바(추후)
                      // 필요 인자: registryList[index]의 index or item자체

                      // 배열 말고 새로운 필드로 테스트 -> 변경됨!
                      CollectionReference registryCollection = FirebaseFirestore.instance.collection('registry');
                      // 기존 wishlist
                      List<WishItem> before = registryItem.wishList; // registryItem.registryId <- 이게 첫번째 registry만 가져온다는 문제잇음
                      // print("before");
                      // before.forEach((element) {
                      //   print(element.toJson());
                      // });
                      List<WishItem> temp = before;
                      temp[index].isBooked = !temp[index].isBooked;
                      List<WishItem> after = temp;

                      Future<void> addWishlistToUpdateReservation() {
                        print("after");
                        after.forEach((element) {
                          print(element.toJson());
                        });
                        return registryCollection
                            .doc(registryItem.registryId)
                            .update({
                          "wishlist": FieldValue.arrayUnion(
                              after.map((e) => e.toJson()).toList()),
                        })
                            .then((value) => print("array added"))
                            .catchError((error) =>
                            print("Failed to add Wishlist: $error"));
                      }

                      Future<void> removeWishlistToUpdateReservation() {
                        // before = registryItem.wishList;
                        // temp = before;
                        print("before");
                        before.forEach((element) {
                          print(element.toJson());
                        });
                        return registryCollection
                            .doc(registryItem.registryId)
                            .update({
                          "wishlist" : FieldValue.arrayRemove(before.map((e) => e.toJson()).toList()),
                        })
                            .then((value) => print("array removed"))
                            .catchError((error) => print("Failed to remove Wishlist: $error"));
                      }
                      removeWishlistToUpdateReservation();
                      addWishlistToUpdateReservation();
                      //temp = [];

                    }
                    else{
                      // 필요 기능: page_wish_reservation으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Reservation()),
                      );
                    }
                  }, // Navigate 필요
                  child: Text('예약'),
                ),
                OutlinedButton(
                  onPressed: () {

                  },
                  child: Text('선물하기'),
                ),
              ],
            );
          }
        ),

      ],
    );
  }

  Future<OpengraphData> _fetchOpengraphData(String url) async {
    return await MetaParser.getOpenGraphData(url);
  }

  _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

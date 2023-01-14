import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:url_launcher/url_launcher.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final firestore = FirebaseFirestore.instance;
  String? curRegistryId;

  Future<RegistryItem> fetchRegistry() async {
    QuerySnapshot<RegistryItem>? snapshot = await FirebaseFirestore.instance
        .collection('registry')
        .where('user.nickname', isEqualTo: '홍길동')
        .withConverter<RegistryItem>(
          fromFirestore: (snapshots, _) =>
              RegistryItem.fromJson(snapshots.data()!),
          toFirestore: (registry, _) => registry.toJson(),
        )
        .limit(1)
        .get();

    curRegistryId = snapshot.docs[0].id;
    RegistryItem registryItem = snapshot.docs.map((e) => e.data()).toList()[0];
    registryItem.registryId = curRegistryId;

    return registryItem;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // 차후에는 firebase에서 데이터 받아서 리스트 생성

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RegistryItem>(
        future: fetchRegistry(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Text('loading');
          } else {
            RegistryItem registryItem = snapshot.data;
            print(registryItem);
            return SingleChildScrollView(
                child: Container(
              child: Column(
                children: [
                  _buildShareBar(),
                  Column(
                      children: registryItem.wishList.map((i) {
                    // reservation과 check의 bool 값에 따라서 분기를 나누려한다.
                    return SizedBox(
                      width: 400,
                      height: 180,
                      child: i.isBooked == true // 예약 상태
                          ? _buildReservationStatusSizebox(i)
                          // 예약 상태가 아님
                          : i.isChecked == true // 선물 받음 체크 한 상태
                              ? _buildCheckStatusSizebox(i)
                              // 선물 받음 체크 안한 상태
                              : i.isReceived == true
                                  ? _buildBeforeCheckStatusSizebox(i)
                                  : _buildAnyStatusSizebox(i),
                    );
                  }).toList()),
                ],
              ),
            ));
          }
        });
  }

  Widget _buildProductImgSizebox(String url) {
    // 이미지 widget
    return Positioned(
      top: 10,
      left: 0,
      child: SizedBox(width: 150, height: 130, child: Image.network(url)),
    );
  }

  Widget _buildProductInfo(String product_name, num product_price) {
    // 상품 이름과 가격 widget
    return Positioned(
        top: 0,
        right: 30,
        child: Column(
          children: [
            Container(
              child: Text(
                product_name,
                style: TextStyle(fontSize: 13),
              ),
              margin: EdgeInsets.only(left: 40, top: 20),
            ),
            Container(
                child: Text(
                  "${product_price}원",
                  style: TextStyle(fontSize: 20),
                ),
                margin: EdgeInsets.only(left: 40, top: 30)),
          ],
        ));
  }

  Widget _buildDescribe(String giver, String describe, double _height,
      double _top, double _right) {
    return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
            padding: EdgeInsets.only(top: _top, right: _right),
            child: Text(
              giver + describe,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white),
            ),
            width: 370,
            height: _height,
            color: Colors.black.withOpacity(0.5)));
  }

  // 선물 받음 체크받은 상태
  Widget _buildCheckStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildDescribe(user_data.giver, '님께 선물을 받았어요.', 200, 170, 5),
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName, user_data.price),
        ],
      ),
    );
  }

  Widget _buildReservationStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildDescribe(user_data.giver, '님이 선물을 예약하셨어요.', 40, 10, 5),
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName, user_data.price),
        ],
      ),
    );
  }

  // 아무 상태 없을 때
  Widget _buildAnyStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName, user_data.price),
        ],
      ),
    );
  }

  Widget _buildBeforeCheckStatusSizebox(user_data) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Colors.black,
      )),
      margin: EdgeInsets.only(top: 30, right: 30),
      child: Stack(
        children: [
          _buildDescribe(user_data.giver, '님이 선물을 보냈어요.', 40, 10, 70),
          Positioned(
              bottom: 5,
              right: 0,
              child: OutlinedButton(
                onPressed: () {},
                child: Text("받음"),
                style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)))),
              )),
          _buildProductImgSizebox(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNYfI9jg0TRgOlwhYgZaJvj_-zl8uhfpcqMw&usqp=CAU'),
          _buildProductInfo(user_data.productName, user_data.price),
        ],
      ),
    );
  }

  Widget _buildShareBar() {
    return Container(
      width: 350,
      height: 50,
      margin: EdgeInsets.only(right: 30),
      alignment: Alignment.center,
      child: OutlinedButton(
          onPressed: () => doShare(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("메세지와 함께 공유하기"),
              Icon(Icons.share),
            ],
          ),
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
          )),
    );
  }

  doShare() {
    if (curRegistryId == null) {
      return;
    }
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: "https://wewish.page.link/",
      link: Uri.parse("https://wewish.com/wishlist?rId=$curRegistryId"),
      androidParameters:
          const AndroidParameters(packageName: "com.codeinsongdo.wewish"),
      iosParameters: const IOSParameters(bundleId: "com.codeinsongdo.wewish"),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: '홍길동님의 위시리스트'
      )
    );
    FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams).then((value) {
      FlutterShare.share(
        title: '위위시',
        text: '홍길동님의 선물리스트',
        linkUrl: value.shortUrl.toString(),
      );
    });
  }


}

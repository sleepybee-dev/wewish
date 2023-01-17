import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wewish/constants.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/page/page_wish_reservation.dart';
import 'package:wewish/provider/provider_user.dart';
import 'package:wewish/ui/card_profile.dart';
import 'package:wewish/ui/card_wish.dart';

import '../util/meta_parser.dart';

class WishListPage extends StatefulWidget {
  final RegistryItem? registryItem;

  const WishListPage({Key? key, this.registryItem}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final registryCollection = FirebaseFirestore.instance.collection('registry');
  String? curRegistryId;
  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.watch();
    if (_userProvider.user != null) {
      Logger logger = Logger(printer: PrettyPrinter());
      logger.d(_userProvider.user!.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              '위시리스트',
            )),
        body: widget.registryItem == null
            ? FutureBuilder<RegistryItem>(
          future: fetchRegistry(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return Text('위시리스트 가져오기 실패');
            }
            RegistryItem registryItem = snapshot.data!;
            return _buildBody(registryItem);
          },
        )
            : _buildBody(widget.registryItem!),
      ),
    );
  }

  Widget _buildBody(RegistryItem registryItem) {
    return Column(
      children: [
        ProfileCard(registryItem.user),
        Expanded(child: _buildWishList(registryItem.wishList)),
      ],
    );
  }

  Widget _buildWishList(List<WishItem> wishList) {
    return ListView.builder(
        itemCount: wishList.length,
        itemBuilder: (context, index) =>
            _buildWishTile(wishList[index], index));
  }

  Widget _buildWishTile(WishItem wishItem, int index) {
    return WishCard(wishItem,
      onReservationPressed: ()=> doReservation(index),
      onPresentPressed: (){},);
  }

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
    // 현재 레지스트리를 가리키도록 수정 필요 -> 완?
    RegistryItem registryItem = snapshot.docs.map((e) => e.data()).toList()[0];
    registryItem.registryId = curRegistryId;

    return registryItem;
  }

  void doReservation(int index) async {
    if (_userProvider.user != null) {
      final ref = await FirebaseFirestore.instance
          .collection('registry')
          .doc(widget.registryItem!.registryId!);
      List<WishItem> before = widget.registryItem!.wishList;
      var tempUser = widget.registryItem!.user;

      List<WishItem> after = before;
      print(after[index].productName);
      print(after[index].isBooked);
      after[index].isBooked = !after[index].isBooked;
      print(after[index].isBooked);
      before.forEach((element) {
        print(element.toJson());
      });
      after.forEach((element) {
        print(element.toJson());
      });

      // set사용
      RegistryItem newfield = RegistryItem(
          user: tempUser, wishList: after, giveList: []);
      ref.set(newfield.toJson());

      // arrayRemove, arrayUnion 말고 set 덮어쓰기로 구현
      // removeWishlistToUpdateReservation(before, registryItem);
      // addWishlistToUpdateReservation(temp, registryItem);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('예약되었습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // 필요 기능: page_wish_reservation으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Reservation()),
      );
    }
  }
}

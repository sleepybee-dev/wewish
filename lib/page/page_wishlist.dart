import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/provider/provider_user.dart';
import 'package:wewish/ui/body_common.dart';
import 'package:wewish/ui/card_profile.dart';
import 'package:wewish/ui/card_wish.dart';

class WishListPage extends StatefulWidget {
  final RegistryItem registryItem;

  const WishListPage({Key? key, required this.registryItem}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final registryCollection = FirebaseFirestore.instance.collection('registry');
  String? curRegistryId;
  late UserProvider _userProvider;
  List<WishItem> _curWishList = [];

  @override
  void initState() {
    super.initState();
    _curWishList = widget.registryItem.wishList;
  }

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
        body: CommonBody(
          showBackButton: true,
            onBackPressed: () => Navigator.of(context).pop(),
            title: '${widget.registryItem.user.nickname}님의 위시리스트',
            child: _buildBody(widget.registryItem)),
      ),
    );
  }

  Widget _buildBody(RegistryItem registryItem) {
    return Column(
      children: [
        ProfileCard(registryItem.user),
        Expanded(child: _buildWishList(_curWishList)),
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
    return WishCard(
      wishItem,
      onReservationPressed: () => doReservation(index),
      onPresentPressed: () => doPresent(index),
      showActionBar: _userProvider.user == null || (widget.registryItem.user.uId != _userProvider.user!.uId!),
    );
  }

  void doReservation(int index) async {
    if (_userProvider.user != null) {
      final ref = FirebaseFirestore.instance
          .collection('registry')
          .doc(widget.registryItem.registryId!);
      List<WishItem> originList = _curWishList;
      List<WishItem> after = originList;

      after[index].isBooked = !after[index].isBooked;
      after[index].actionUser = after[index].isBooked ? _userProvider.user : null;

      String message = after[index].isBooked ? '예약되었습니다.' : '예약취소되었습니다.';

      List<WishItem> newWishList = after;
      ref.update({'wishlist': newWishList.map((e) => e.toJson()).toList()}).then((value) {
        WishItem actionItem = after[index]..wishUser = widget.registryItem.user;
        _updateMyAction(actionItem);
        setState(() {
          _curWishList = newWishList;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 1),
          ),
        );
      });
    } else {
      // [TODO] 필요 기능: page_wish_reservation으로 이동
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Reservation()),
      // );
      showLoginInfoSnackbar();
    }
  }

  void showLoginInfoSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인이 필요한 액션입니다.'),));
  }

  void doPresent(int index) {
    if (_userProvider.user == null) {
      showLoginInfoSnackbar();
    } else {
      final ref = FirebaseFirestore.instance
          .collection('registry')
          .doc(widget.registryItem.registryId!);
      List<WishItem> originList = _curWishList;
      List<WishItem> after = originList;

      after[index].isPresented = !after[index].isPresented;
      after[index].actionUser = after[index].isPresented ? _userProvider.user : null;

      String message = after[index].isPresented ? '선물하였습니다.' : '선물 표시 취소되었습니다.';

      List<WishItem> newWishList = after;
      ref.update({'wishlist': newWishList.map((e) => e.toJson()).toList()}).then((value) {
        WishItem actionItem = after[index]..wishUser = widget.registryItem.user;
        _updateMyAction(actionItem);
        setState(() {
          _curWishList = newWishList;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 1),
          ),
        );
      });
    }
  }

  void _updateMyAction(WishItem actionItem) async {
    if (_userProvider.user != null) {
      final snapshot = await FirebaseFirestore.instance.collection('registry').where('user.uId', isEqualTo: _userProvider.user!.uId)
          .get();
      if (snapshot.docs.isEmpty) {
        FirebaseFirestore.instance.collection('registry').add(
          {
            'user': _userProvider.user!.toJson(),
            'actions': [actionItem.toString()]
          }
        );
      } else {
        snapshot.docs[0].reference.update({
          'actions' : FieldValue.arrayUnion([actionItem.toJson()])
        });
      }
    }
  }
}

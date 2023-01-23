import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_action.dart';
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
        ProfileCard(registryItem.user, wishCount: registryItem.wishList.length,),
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

      ActionStatus newAction = generateNewAction(originList[index].actionList, isBook:true);
      ActionItem newActionItem = ActionItem(_userProvider.user!, DateTime.now().toLocal(), newAction);
      originList[index].actionList.add(newActionItem);
      String message = newAction == ActionStatus.book ? '예약되었습니다.' : '예약취소되었습니다.';

      ref.update({'wishlist': originList.map((e) => e.toJson()).toList()}).then((value) {
        _updateMyAction(originList[index]);
        setState(() {
          _curWishList = originList;
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

      ActionStatus newAction = generateNewAction(originList[index].actionList, isBook:false);
      ActionItem newActionItem = ActionItem(_userProvider.user!, DateTime.now().toLocal(), newAction);

      // 액션 추가
      originList[index].actionList.add(newActionItem);

      String message = newAction == ActionStatus.present ? '선물하였습니다.' : '선물 표시 취소되었습니다.';

      ref.update({'wishlist': originList.map((e) => e.toJson()).toList()}).then((value) {
        WishItem actionItem = originList[index]..wishUser = widget.registryItem.user;
        _updateMyAction(originList[index]);
        setState(() {
          _curWishList = originList;
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

  void _updateMyAction(WishItem newWish) async {
    if (_userProvider.user != null) {
      final snapshot = await FirebaseFirestore.instance.collection('registry').where('user.uId', isEqualTo: _userProvider.user!.uId)
          .get();
      if (snapshot.docs.isEmpty) {
        FirebaseFirestore.instance.collection('registry').add(
          {
            'user': _userProvider.user!.toJson(),
            'actions': [newWish.toString()]
          }
        );
      } else {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot transSnapshot = await transaction.get(snapshot.docs[0].reference);
          if (!transSnapshot.exists) {
            throw Exception('Does not exists');
          } else {
            final docRef = transSnapshot.get('actions');
            if (docRef == null) {
              transaction.update(transSnapshot.reference, {
                'actions': [newWish.toJson()]
              });
            } else {
              final actions = docRef as List<dynamic>;
              List<WishItem> resultActions = actions.map((e) =>
                  WishItem.fromJson(e)).toList();
              for (dynamic action in actions) {
                WishItem actionWish = WishItem.fromJson(
                    action as Map<String, dynamic>);
                if (actionWish.url == newWish.url) {
                  resultActions.removeWhere((item) => item.url == newWish.url);
                  resultActions.add(newWish);
                  transaction.update(transSnapshot.reference, {
                    'actions': resultActions.map((e) => e.toJson()).toList()});
                }
              }
            }
          }
        });
      }
    }
  }

  ActionStatus generateNewAction(List<ActionItem> actionList, {required bool isBook}) {
    if (actionList.isEmpty) {
      return ActionStatus.none;
    } else {
      if (isBook) {
        return actionList.last.actionStatus == ActionStatus.book
            ? ActionStatus.bookCancel
            : ActionStatus.book;
      } else {
        return actionList.last.actionStatus == ActionStatus.present
            ? ActionStatus.presentCancel
            : ActionStatus.present;
      }
    }
  }
}

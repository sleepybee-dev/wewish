import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/ui/card_wish.dart';
import 'package:wewish/util/meta_parser.dart';

import '../model/item_action.dart';

class ActionList extends StatefulWidget {
  UserItem currentUser;
  List<WishItem> actionWishList;

  ActionList(this.actionWishList, {Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  List<WishItem> actionWishList = [];

  @override
  void initState() {
    super.initState();
    actionWishList = widget.actionWishList;
  }

  @override
  Widget build(BuildContext context) {
    // initializeDateFormatting('ko', '');
    return ListView.builder(
        itemCount: widget.actionWishList.length,
        itemBuilder: (context, index) {
          ActionItem lastAction = actionWishList[index].actionList.last;
          String action = lastAction.actionStatus.label;
          String actionDate =
              DateFormat('yy/MM/dd HH:mm').format(lastAction.actionDate);
          Logger(printer: PrettyPrinter()).d("action : $actionDate");
          // String actionDate = DateFormat('yy-MM-DD HH:mm', 'ko').format(actions[index].actionDate!.toLocal());
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    '┎ ${actionWishList[index].wishUser!.nickname} 님의 위시를 ${actionDate}에 $action했어요.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                WishCard(actionWishList[index],
                    onReservationPressed: () => doReservation(index),
                    onPresentPressed: () => doPresent(index)),
              ]);
        });
  }

  void doReservation(int index) async {
    WishItem originWish = widget.actionWishList[index];
    DateTime actionDate = DateTime.now().toLocal();
    ActionStatus curAction = originWish.actionList.last.actionStatus;
    ActionStatus newAction = curAction == ActionStatus.book ? ActionStatus.bookCancel : ActionStatus.book;
    // 액션리스트 추가시킴.
    originWish.actionList
        .add(ActionItem(widget.currentUser, actionDate, newAction));

    // 1. 위시 주인의 상태를 바꾼다.
    final snapshot = await FirebaseFirestore.instance
        .collection('registry')
        .where('user.uId', isEqualTo: originWish.wishUser!.uId)
        .get();

    setState(() {
      actionWishList[index] = originWish;
    });

    if (snapshot.docs.isNotEmpty) {
      snapshot.docs[0].reference.update({'wishlist': actionWishList});
    }

    // 2. 나의 액션 리스트를 업뎃한다.
    _updateMyAction(originWish);
    String message = originWish.actionList.last.actionStatus == ActionStatus.book ? '예약하였습니다.' : '예약 취소되었습니다.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void doPresent(int index) async {
    WishItem originWish = widget.actionWishList[index];
    DateTime actionDate = DateTime.now().toLocal();
    ActionStatus curAction = originWish.actionList.last.actionStatus;
    ActionStatus newAction = curAction == ActionStatus.present ? ActionStatus.presentCancel : ActionStatus.present;
    // 액션리스트 추가시킴.
    originWish.actionList
        .add(ActionItem(widget.currentUser, actionDate, newAction));

    // 1. 위시 주인의 상태를 바꾼다.
    final snapshot = await FirebaseFirestore.instance
        .collection('registry')
        .where('user.uId', isEqualTo: originWish.wishUser!.uId)
        .get();

    setState(() {
      actionWishList[index] = originWish;
    });

    if (snapshot.docs.isNotEmpty) {
      snapshot.docs[0].reference.update({'wishlist': actionWishList});
    }

    // 2. 나의 액션 리스트를 업뎃한다.
    _updateMyAction(originWish);
    String message = originWish.actionList.last.actionStatus == ActionStatus.present ? '선물하였습니다.' : '선물 표시 취소되었습니다.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _updateMyAction(WishItem newWish) async {
      final snapshot = await FirebaseFirestore.instance
          .collection('registry')
          .where('user.uId', isEqualTo: widget.currentUser.uId)
          .get();
      if (snapshot.docs.isEmpty) {
        FirebaseFirestore.instance.collection('registry').add({
          'user': widget.currentUser.toJson(),
          'actions': [newWish.toString()]
        });
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/ui/card_wish.dart';
import 'package:wewish/util/meta_parser.dart';

class ActionList extends StatefulWidget {
  List<WishItem> actionList;

  ActionList(this.actionList, {Key? key}) : super(key: key);

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {
  List<WishItem> actions = [];

  @override
  void initState() {
    super.initState();
    actions = widget.actionList;
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.actionList.length,
        itemBuilder: (context, index) {
          String action = actions[index].isBooked ? '예약' : (actions[index].isPresented ? '선물' : '선물취소');
          return Stack(children: [
            WishCard(actions[index],
                onReservationPressed: () => doPresent(index),
                onPresentPressed: ()  => doPresent(index)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  '${actions[index].wishUser!.nickname} 님의 위시를 ${DateFormat('yy-MM-dd', 'en_US').format(actions[index].actionDate!)}에 $action했어요.',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]);
        });
  }

  void doPresent(int index) async {
    WishItem originWish = widget.actionList[index];
    WishItem newWish = originWish..isPresented = !originWish.isPresented;

    // 1. 위시 주인의 상태를 바꾼다.
    final snapshot = await FirebaseFirestore.instance
        .collection('registry')
        .where('user.uId', isEqualTo: originWish.wishUser!.uId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      snapshot.docs[0].reference.update({
        'wishlist': FieldValue.arrayRemove([originWish.toJson()])
      });
      snapshot.docs[0].reference.update({
        'wishlist': FieldValue.arrayUnion([newWish.toJson()])
      });
    }

    // 2. 나의 액션 리스트를 업뎃한다.
    final actionSnapshot = await FirebaseFirestore.instance
    .collection('registry')
    .where('user.uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .get();

    if (actionSnapshot.docs.isNotEmpty) {
      actionSnapshot.docs[0].reference.update({
        'actions': FieldValue.arrayRemove([originWish.toJson()])
      });
      actionSnapshot.docs[0].reference.update({
        'actions': FieldValue.arrayUnion([newWish.toJson()])
      }).then((value) {
        setState(() {
          actions[index] = newWish;
        });
        String message = newWish.isPresented ? '선물하였습니다.' : '선물 표시 취소되었습니다.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 1),
          ),
        );
      });
    }
  }
}

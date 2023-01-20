import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.actionList.length,
        itemBuilder: (context, index) {
      return Stack(children: [
        WishCard(widget.actionList[index], onReservationPressed: (){}, onPresentPressed: (){}),
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          child: Text('${widget.actionList[index].wishUser!.nickname}님의 위시'),),
      ]);
    });
  }
}

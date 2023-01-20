import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/util/meta_parser.dart';

class WishCard extends StatefulWidget {
  WishItem wishItem;
  VoidCallback onReservationPressed;
  VoidCallback onPresentPressed;
  bool showStatus = false;
  bool showActionBar = true;

  WishCard(this.wishItem,
      {Key? key,
      required this.onReservationPressed,
      required this.onPresentPressed,
      this.showStatus = false,
      this.showActionBar = true})
      : super(key: key);

  @override
  State<WishCard> createState() => _WishCardState();
}

class _WishCardState extends State<WishCard> {
  WishStatus _curStatus = WishStatus.none;

  @override
  Widget build(BuildContext context) {
    _curStatus = generateStatus(widget.wishItem);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 140,
        child: Stack(children: [
          widget.showStatus ? _buildStatusLabel(widget.wishItem) : Container(),
          Card(
            child: SizedBox(
              height: 180,
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: FutureBuilder<OpengraphData>(
                        future: _fetchOpengraphData(widget.wishItem.url),
                        builder: (context, snapshot) {
                          Logger(printer: PrettyPrinter()).d(snapshot);
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data == null)) {
                            return Container(
                              color: Theme.of(context).canvasColor,
                            );
                          }
                          return GestureDetector(
                              onTap: () => _launchUrl(widget.wishItem.url),
                              child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    SizedBox(
                                        height:120,
                                        child: Image.network(snapshot.data!.image, fit: BoxFit.cover,)),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.link, color: Colors.white,),
                                    ),
                                  ]));
                        }),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.wishItem.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.wishItem.category.category,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.wishItem.price.toString()}원',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          widget.showActionBar
                              ? _buildActionButtonBar()
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
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

  Widget _buildStatusLabel(WishItem wishItem) {
    WishStatus curStatus = generateStatus(widget.wishItem);
    String message = '';
    switch (curStatus) {
      case WishStatus.none:
        return Container();
      case WishStatus.bookedByMyself:
      case WishStatus.bookedBySomeone:
        if (wishItem.actionUser != null) {
          message = '${wishItem.actionUser!.nickname}님이 예약하셨어요.';
        }
        break;
      case WishStatus.presentedByMySelf:
      case WishStatus.presentedBySomeone:
        if (wishItem.actionUser != null) {
          message = '${wishItem.actionUser!.nickname}님이 선물하셨어요.';
        }
        break;
      case WishStatus.given:
        if (wishItem.actionUser != null) {
          message = '${wishItem.actionUser!.nickname}님께 선물 받았어요.';
        }
        break;
    }

    return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
            height: 40,
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
            ),
            color: Colors.black.withOpacity(0.5)));
  }

  WishStatus generateStatus(WishItem wishItem) {
    if (wishItem.isBooked) {
      if (FirebaseAuth.instance.currentUser != null &&
          wishItem.actionUser != null &&
          wishItem.actionUser!.uId == FirebaseAuth.instance.currentUser!.uid) {
        return WishStatus.bookedByMyself;
      }
      return WishStatus.bookedBySomeone;
    }
    if (wishItem.isPresented) {
      if (FirebaseAuth.instance.currentUser != null &&
          wishItem.actionUser != null &&
          wishItem.actionUser!.uId == FirebaseAuth.instance.currentUser!.uid) {
        return WishStatus.presentedByMySelf;
      }
      return WishStatus.presentedBySomeone;
    }
    if (wishItem.isReceived) {
      return WishStatus.given;
    }
    return WishStatus.none;
  }

  Widget _buildActionButtonBar() {
    return SizedBox(
      height: 56,
      child: ButtonBar(
        alignment: MainAxisAlignment.end,
        children: [_buildReservationButton(), _buildPresentButton()],
      ),
    );
  }

  Widget _buildReservationButton() {
    bool showCancelButton = _curStatus == WishStatus.bookedByMyself;
    bool showDisableButton = _curStatus == WishStatus.bookedBySomeone ||
        _curStatus == WishStatus.presentedBySomeone ||
        _curStatus == WishStatus.presentedByMySelf ||
        _curStatus == WishStatus.given;

    return ElevatedButton(
      style:
          ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) {
        return showDisableButton
            ? Colors.black12
            : Theme.of(context).primaryColor;
      })),
      onPressed: _curStatus == WishStatus.bookedBySomeone
          ? () => _showSnackBar(FirebaseAuth.instance.currentUser == null ? '로그인이 필요한 액션입니다.':'다른 사람이 선물 예약했어요.')
          : widget.onReservationPressed, // Navigate 필요
      child: Text(
        showCancelButton ? '예약취소' : '예약',
        style: TextStyle(color: showCancelButton ? Colors.grey : Colors.white),
      ),
    );
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  Widget _buildPresentButton() {
    bool showCancelButton = _curStatus == WishStatus.presentedByMySelf;
    bool showDisableButton = _curStatus == WishStatus.bookedBySomeone ||
        _curStatus == WishStatus.presentedBySomeone ||
        _curStatus == WishStatus.presentedByMySelf ||
        _curStatus == WishStatus.given;

    return ElevatedButton(
        onPressed: _curStatus == WishStatus.presentedBySomeone
            ? () => _showSnackBar('다른 사람이 선물 표시했어요.')
            : widget.onPresentPressed,
        child: Text(
          showCancelButton ? '선물취소' : '선물하기',
          style:
              TextStyle(color: showCancelButton ? Colors.grey : Colors.white),
        ));
  }
}

enum WishStatus {
  none,
  bookedBySomeone,
  bookedByMyself,
  presentedBySomeone,
  presentedByMySelf,
  given
}

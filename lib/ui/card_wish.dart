import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _launchUrl(widget.wishItem.url),
        child: Stack(children: [
          widget.showStatus ? _buildStatusLabel(widget.wishItem) : Container(),
          Card(
            child: Column(
              children: [
                Container(
                  color: Color(0xff97d2f8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(widget.wishItem.productName)),
                        Text(
                          widget.wishItem.price.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                widget.showActionBar ? ButtonBar(
                  alignment: MainAxisAlignment.end,
                  buttonPadding: EdgeInsets.only(left: 20),
                  children: [
                    // 임시 로그인/로그아웃을 위한 버튼
                    ElevatedButton(
                      onPressed: widget.onReservationPressed, // Navigate 필요
                      child: Text('예약'),
                    ),
                    OutlinedButton(
                      onPressed: widget.onPresentPressed,
                      child: Text('선물하기'),
                    ),
                  ],
                ) : Container(),
                FutureBuilder<OpengraphData>(
                    future: _fetchOpengraphData(widget.wishItem.url),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          (snapshot.connectionState == ConnectionState.done &&
                              snapshot.data == null)) {
                        return Container(
                          height: 120,
                          color: Colors.grey,
                        );
                      }
                      return _buildOpenGraphBox(snapshot.data!);
                    })
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildOpenGraphBox(OpengraphData opengraphData) {
    return Column(
      children: [
        SizedBox(
            height: 100,
            child: Image.network(
              opengraphData.image,
              fit: BoxFit.cover,
            )),
        Text(
          opengraphData.title,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(opengraphData.description),
        Text(
          opengraphData.url,
          style: TextStyle(fontSize: 12, color: Colors.grey),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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

  Widget _buildStatusLabel(WishItem wishItem) {
    WishStatus curStatus = generateStatus(widget.wishItem);
    String message = '';
    switch (curStatus) {
      case WishStatus.none:
        return Container();
      case WishStatus.booked:
        if (wishItem.actionUser != null) {
          message = '${wishItem.actionUser!.nickname}님이 예약하셨어요.';
        }
        break;
      case WishStatus.presented:
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
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.black.withOpacity(0.5)));
  }

  WishStatus generateStatus(WishItem wishItem) {
    if (wishItem.isBooked) {
      return WishStatus.booked;
    }
    if (wishItem.isChecked) {
      return WishStatus.presented;
    }
    if (wishItem.isReceived) {
      return WishStatus.given;
    }
    return WishStatus.none;
  }
}

enum WishStatus { none, booked, presented, given }

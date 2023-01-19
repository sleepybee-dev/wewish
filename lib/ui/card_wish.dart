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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _launchUrl(widget.wishItem.url),
        child: SizedBox(
          height: 140,
          child: Stack(children: [
            widget.showStatus
                ? _buildStatusLabel(widget.wishItem)
                : Container(),
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
                            Logger(printer:PrettyPrinter()).d(snapshot);
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data == null)) {
                              return Container(
                                height: 120,
                                color: Theme.of(context).canvasColor,
                              );
                            }
                            return Image.network(snapshot.data!.image);
                          }),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.wishItem.productName, maxLines: 2, overflow: TextOverflow.ellipsis,),
                            Text(
                              widget.wishItem.category.category,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${widget.wishItem.price.toString()}원',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _buildOpenGraphBox(OpengraphData opengraphData) {
    return Column(
      children: [
        SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              opengraphData.image,
              fit: BoxFit.cover,
            )),
        // Text(
        //   opengraphData.title,
        //   style: TextStyle(fontWeight: FontWeight.bold),
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
        // Text(opengraphData.description),
        // Text(
        //   opengraphData.url,
        //   style: TextStyle(fontSize: 12, color: Colors.grey),
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
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
          height: 40,
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

  Widget _buildActionButtonBar() {
    return SizedBox(
      height: 56,
      child: ButtonBar(
        alignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed:
            widget.onReservationPressed, // Navigate 필요
            child: Text('예약'),
          ),
          OutlinedButton(
            onPressed: widget.onPresentPressed,
            child: Text('선물하기'),
          ),
        ],
      ),
    );
  }
}

enum WishStatus { none, booked, presented, given }

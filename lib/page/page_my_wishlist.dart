import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/provider/provider_user.dart';
import 'package:wewish/ui/card_wish.dart';

class MyWishList extends StatefulWidget {
  List<WishItem> wishList;
  String registryId;

  MyWishList(this.wishList, {Key? key, required this.registryId}) : super(key: key);

  @override
  State<MyWishList> createState() => _MyWishListState();
}

class _MyWishListState extends State<MyWishList> {

  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.watch<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildShareBar(),
        Expanded(child:
        ListView.builder(
          itemCount: widget.wishList.length,
            itemBuilder: (context, index)
        => WishCard(widget.wishList[index],
            showStatus: true,
            showActionBar: false,
            onReservationPressed: (){},
            onPresentPressed: (){}))),
      ],
    );
  }

  Widget _buildShareBar() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(left:30, right: 30),
      alignment: Alignment.center,
      child: OutlinedButton(
          onPressed: () => doShare(),
          style: OutlinedButton.styleFrom(
            primary: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("내 위시리스트 공유하기"),
              const Icon(Icons.share),
            ],
          )),
    );
  }

  doShare() {
    if (_userProvider.user == null) {
      return;
    }
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: "https://wewish.page.link/",
      link: Uri.parse("https://wewish.com/wishlist?rId=${widget.registryId}"),
      androidParameters:
          const AndroidParameters(packageName: "com.codeinsongdo.wewish"),
      iosParameters: const IOSParameters(bundleId: "com.codeinsongdo.wewish"),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: '${_userProvider.user!.nickname}님의 위시리스트'
      )
    );
    FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams).then((value) {
      FlutterShare.share(
        title: '위위시',
        text: '${_userProvider.user!.nickname}님의 선물리스트',
        linkUrl: value.shortUrl.toString(),
      );
    });
  }


}

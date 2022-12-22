import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/util/meta_parser.dart';

class RegistryPage extends StatelessWidget {
  final RegistryItem registryItem;

  const RegistryPage({Key? key, required this.registryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildUserProfile(registryItem.user),
            Expanded(child: _buildWishList(registryItem.wishList)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(UserItem user) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Colors.amberAccent,
            backgroundImage: NetworkImage(user.profileUrl),
            radius: 18.0,
          ),
        ),
        Expanded(child: Text(user.nickname))
      ],
    );
  }

  Widget _buildWishList(List<WishItem> wishList) {
    return ListView.builder(
        itemCount: wishList.length,
        itemBuilder: (context, index) => _buildWishTile(wishList[index]));
  }

  Widget _buildWishTile(WishItem wishItem) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => _launchUrl(wishItem.url),
        child: Card(
          child: Column(
            children: [
              Container(
                color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(wishItem.name)),
                      Text(wishItem.price.toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              FutureBuilder<OpengraphData>(
                  future: _fetchOpengraphData(wishItem.url),
                  builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || (snapshot.connectionState == ConnectionState.done && snapshot.data == null)) {
                  return Container(height: 120, color: Colors.grey,);
                }
                return _buildOpenGraphBox(snapshot.data!);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpenGraphBox(OpengraphData opengraphData) {
    return Column(
      children: [
        SizedBox(
          height: 100,
            child: Image.network(opengraphData.image, fit: BoxFit.cover,)),
        Text(opengraphData.title, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
        Text(opengraphData.description),
        Text(opengraphData.url, style: TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis,),
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
}

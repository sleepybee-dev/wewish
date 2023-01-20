import 'package:flutter/material.dart';
import 'package:wewish/constants.dart';
import 'package:wewish/model/item_user.dart';

class ProfileCard extends StatelessWidget {

  UserItem userItem;
  int? wishCount;

  ProfileCard(this.userItem, {Key? key, this.wishCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0, right: 8.0, top:4, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xffeeeeee).withOpacity(0.5)
        ),
        height: 100,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            wishCount != null ? _buildWishCountLabel(wishCount!) : Container(),
            Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:20.0, right: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  backgroundImage: NetworkImage(userItem.profileUrl ?? defaultProfileUrl),
                  radius: 36.0,
                ),
              ),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userItem.nickname, style: Theme.of(context).textTheme.titleLarge,),
                      SizedBox(
                        height: 24,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: userItem.hashTag.length,
                            itemBuilder: (context, index) {
                              return _buildHashTagText(userItem.hashTag[index]);
                            }),
                      )
                    ],
                  ))
            ],
          ),]
        ),
      ),
    );
  }

  _buildHashTagText(String hashtag) {
    return Text("#$hashtag",
        style: const TextStyle(
          fontSize: 13,
        ));
  }

  Widget _buildWishCountLabel(int wishCount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        width: 72,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Text('$wishCount 위시', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
    );
  }

}

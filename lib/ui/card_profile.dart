import 'package:flutter/material.dart';
import 'package:wewish/constants.dart';
import 'package:wewish/model/item_user.dart';

class ProfileCard extends StatelessWidget {

  UserItem userItem;

  ProfileCard(this.userItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundColor: Colors.amberAccent,
              backgroundImage: NetworkImage(userItem.profileUrl ?? defaultProfileUrl),
              radius: 30.0,
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userItem.nickname, style: Theme.of(context).textTheme.labelLarge,),
                  Expanded(
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
      ),
    );
  }

  _buildHashTagText(String hashtag) {
    return Text("#" + hashtag,
        style: TextStyle(
          fontSize: 13,
        ));
  }

}

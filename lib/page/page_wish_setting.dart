import 'package:flutter/material.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/util/category_parser.dart';

class WishSettingPage extends StatefulWidget {

  // WishItem? wishItem;

  WishSettingPage({Key? key}) : super(key: key);

  @override
  State<WishSettingPage> createState() => _WishSettingPageState();
}

class _WishSettingPageState extends State<WishSettingPage> {


  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CategoryParser.getCategoryMap("beauty");

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(title:Text('')),
            body: _buildBody()));
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(
          children: [
            Text('name'),
            Expanded(child: TextField())
          ],
        ),
        Row(
          children: [
            Text('url'),
            Expanded(child: TextField(
              controller: _editingController,
            ))
          ],
        ),
      ],
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_category.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/util/category_parser.dart';

class WishSettingPage extends StatefulWidget {
  // WishItem? wishItem;

  WishSettingPage({Key? key}) : super(key: key);

  @override
  State<WishSettingPage> createState() => _WishSettingPageState();
}

class _WishSettingPageState extends State<WishSettingPage> {
  TextEditingController _editingController = TextEditingController();
  late RegistryProvider _registryProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registryProvider = Provider.of<RegistryProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _checkClipboard().then((clipboardText) {
      if (clipboardText != null) {
        _showCopySnackBar(clipboardText);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(appBar: AppBar(title: Text('')), body: _buildBody()));
  }

  String _curCategory = '뷰티';
  Map<String, List<String>>? _curCategoryMap;
  String _curPart1 = '';
  String _curPart2 = '';

  Widget _buildBody() {
    return Stack(children: [
      _onLoading
          ? Center(
              child: Container(
              child: CircularProgressIndicator(),
            ))
          : Container(),
      Column(
        children: [
          Row(
            children: [Text('name'), Expanded(child: TextField())],
          ),
          Row(
            children: [
              Text('url'),
              Expanded(
                  child: TextField(
                controller: _editingController,
              ))
            ],
          ),
          TextButton(
              onPressed: _showCategoryBottomSheet, child: Text(_curCategory)),
          TextButton(
              onPressed: () => _curCategoryMap != null
                  ? _showCategoryPart1Sheet(_curCategoryMap!)
                  : {},
              child: Text(_curPart1)),
          TextButton(
              onPressed: () => _curCategoryMap != null
                  ? _showCategoryPart2Sheet(_curCategoryMap![_curPart1])
                  : {},
              child: Text(_curPart2)),
          TextButton(onPressed: () => _addWish(), child: Text('위시 추가'))
        ],
      ),
    ]);
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: Category.values.length,
            itemBuilder: (context, index) {
              Category categoryItem = Category.values[index];
              return TextButton(
                  onPressed: () {
                    setState(() {
                      _curCategory = categoryItem.label;
                    });
                    Navigator.pop(context);
                    _fetchCategoryPart(categoryItem);
                  },
                  child: Text(categoryItem.label));
            },
          );
        });
  }

  bool _onLoading = false;

  void _fetchCategoryPart(Category category) {
    setState(() {
      _onLoading = true;
    });
    CategoryParser.getCategoryMap(category).then((categoryMap) {
      _curCategoryMap = categoryMap;
      setState(() {
        _onLoading = false;
      });
      _showCategoryPart1Sheet(categoryMap);
    });
  }

  Future<String?> _checkClipboard() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      if (clipboardData.text != null && clipboardData.text!.contains("http")) {
        return clipboardData.text!;
      }
    }
    return null;
  }

  void _showCopySnackBar(String clipboardText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(clipboardText),
      action: SnackBarAction(
        label: '붙여넣기',
        onPressed: () {
          setState(() {
            _editingController.text = clipboardText;
          });
        },
      ),
    ));
  }

  void _showCategoryPart2Sheet(List<String>? part2List) {
    if (part2List == null || part2List.isEmpty) {
      return;
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
              itemCount: part2List.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _curPart2 = part2List[index];
                    });
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 40,
                      child: Text(part2List[index])),
                );
              });
        });
  }

  void _showCategoryPart1Sheet(Map<String, List<String>> categoryMap) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<String> keys = categoryMap.keys.toList();
          return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _curPart1 = keys[index];
                    });
                    Navigator.pop(context);
                    _showCategoryPart2Sheet(categoryMap[keys[index]]);
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      height: 40,
                      child: Text(keys[index])),
                );
              });
        });
  }

  _addWish() {
    CategoryItem categoryItem = CategoryItem()
      ..category = _curCategory
      ..part1 = _curPart1
      ..part2 = _curPart2;

    WishItem wishItem = WishItem()
      ..createdDate = DateTime.now()
      ..modifiedDate = DateTime.now()
      ..name = ''
      ..price = 200
      ..url = _editingController.text
      ..category = categoryItem;

    _registryProvider.addRegistry("HcRzmebMekTFo4w9jm2u", wishItem);
  }
}

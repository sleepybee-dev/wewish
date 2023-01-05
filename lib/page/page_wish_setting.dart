import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_category.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/ui/button_text_primary.dart';
import 'package:wewish/util/category_parser.dart';

class WishSettingPage extends StatefulWidget {
  // WishItem? wishItem;
  String? url;

  WishSettingPage({Key? key, this.url}) : super(key: key);

  @override
  State<WishSettingPage> createState() => _WishSettingPageState();
}

class _WishSettingPageState extends State<WishSettingPage> with WidgetsBindingObserver{
  final TextEditingController _urlEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();

  late RegistryProvider _registryProvider;
  final GlobalKey _scaffoldKey = GlobalKey();

  final CategoryItem _curCategoryItem = CategoryItem();
  Map<String, List<String>>? _curCategoryMap;
  String _curProductName = '';
  int _curPrice = 0;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registryProvider = Provider.of<RegistryProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _doCheckClipboard();
    WidgetsBinding.instance.addObserver(this);
    if (widget.url != null) {
      _urlEditingController.text = widget.url!;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logger logger = Logger(printer: PrettyPrinter());
    logger.d(state);
    if (state == AppLifecycleState.resumed) {
      _doCheckClipboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(appBar: AppBar(title: const Text('')), body: _buildBody()));
  }

  Widget _buildBody() {
    return Stack(children: [
      _onLoading
          ? Center(
              child: Container(
              child: const CircularProgressIndicator(),
            ))
          : Container(),
      Column(
        children: [
          Row(
            children: [
              const Text('url'),
              Expanded(
                  child: TextField(
                controller: _urlEditingController,
              ))
            ],
          ),
          Row(
            children: [const Text('상품명'), Expanded(child: TextField(
              controller: _nameEditingController,

            ))],
          ),
          Row(
            children: [const Text('상품가격'), Expanded(child: TextField(
              keyboardType: const TextInputType.numberWithOptions(),
              controller: _priceEditingController,
            ))],
          ),
          TextButton(
              onPressed: _showCategoryBottomSheet, child: Container(
            alignment: Alignment.center,
            width: double.infinity,
              height: 56,
              child: Text(_curCategoryItem.category.isEmpty ? '카테고리 선택' : _curCategoryItem.category, style: TextStyle(color: Theme.of(context).primaryColor),))),
          TextButton(
              onPressed: () => _curCategoryMap != null
                  ? _showCategoryPart1Sheet(_curCategoryMap!)
                  : {},
              child: Text(_curCategoryItem.part1)),
          TextButton(
              onPressed: () => _curCategoryMap != null
                  ? _showCategoryPart2Sheet(_curCategoryMap![_curCategoryItem.part1])
                  : {},
              child: Text(_curCategoryItem.part2)),
          PrimaryTextButton(onPressed: () => _addWish(), label: '위시 추가')
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
                      _curCategoryItem.category = categoryItem.label;
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

  Future<String?> _fetchClipboardData() async {
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
      key: _scaffoldKey,
      duration: const Duration(seconds: 5),
      content: Text(clipboardText, maxLines: 2, overflow: TextOverflow.ellipsis,),
      action: SnackBarAction(
        label: '붙여넣기',
        onPressed: () {
          setState(() {
            _urlEditingController.text = clipboardText;
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
                      _curCategoryItem.part2 = part2List[index];
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
                      _curCategoryItem.part1 = keys[index];
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
    CategoryItem categoryItem = _curCategoryItem;

    WishItem wishItem = WishItem()
      ..createdDate = DateTime.now()
      ..modifiedDate = DateTime.now()
      ..name = _nameEditingController.text
      ..price = _priceEditingController.text as int
      ..url = _urlEditingController.text
      ..category = categoryItem;

    _registryProvider.addRegistry("HcRzmebMekTFo4w9jm2u", wishItem);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _doCheckClipboard() {
    _fetchClipboardData().then((clipboardText) {
      if (clipboardText != null) {
        _showCopySnackBar(clipboardText);
      }
    });
  }
}

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_category.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/ui/button_text_primary.dart';
import 'package:wewish/util/category_parser.dart';
import 'package:wewish/util/meta_parser.dart';

class WishEditPage extends StatefulWidget {
  // WishItem? wishItem;
  String? url;

  WishEditPage({Key? key, this.url}) : super(key: key);

  @override
  State<WishEditPage> createState() => _WishEditPageState();
}

class _WishEditPageState extends State<WishEditPage>
    with WidgetsBindingObserver {
  final TextEditingController _urlEditingController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _priceEditingController = TextEditingController();

  late RegistryProvider _registryProvider;
  final GlobalKey _scaffoldKey = GlobalKey();

  final CategoryItem _curCategoryItem = CategoryItem();
  Map<String, List<CategorySingle>>? _curCategoryMap;

  OpengraphData? opengraphData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registryProvider = Provider.of<RegistryProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.url != null) {
      _urlEditingController.text = widget.url!;
      _parseUrl(widget.url!);
    }
    if (widget.url == null && _urlEditingController.text.isEmpty) {
      _doCheckClipboard();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logger logger = Logger(printer: PrettyPrinter());

    logger.d(state);
    if (state == AppLifecycleState.resumed) {
      if (widget.url == null && _urlEditingController.text.isEmpty) {
        _doCheckClipboard();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text('')), body: _buildBody()));
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
          _buildOgDataCard(),
          Row(
            children: [
              const Text('url'),
              Expanded(
                  child: TextField(
                controller: _urlEditingController,
                    onEditingComplete: ()=>
                        _parseUrl(_urlEditingController.text),
              ))
            ],
          ),
          Row(
            children: [
              const Text('상품명'),
              Expanded(
                  child: TextField(
                controller: _nameEditingController,
              ))
            ],
          ),
          Row(
            children: [
              const Text('상품가격'),
              Expanded(
                  child: TextField(
                keyboardType: const TextInputType.numberWithOptions(),
                controller: _priceEditingController,
              ))
            ],
          ),
          TextButton(
              onPressed: _showCategoryBottomSheet,
              child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 56,
                  child: Text(
                    _curCategoryItem.category.isEmpty
                        ? '카테고리 선택'
                        : _curCategoryItem.category,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))),
          TextButton(
              onPressed: () => _curCategoryMap != null
                  ? _showCategoryPart1Sheet(_curCategoryMap!)
                  : {},
              child: Text(_curCategoryItem.part1)),
          TextButton(
              onPressed: () => _curCategoryMap != null
                  ? _showCategoryPart2Sheet(
                      _curCategoryMap![_curCategoryItem.part1])
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
        final reg = RegExp(
            "https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%_\\+.~#()?&//=]*)");
        final matchResult = reg.stringMatch(clipboardData.text!);
        return matchResult;
      }
    }
    return null;
  }

  void _showCopySnackBar(String clipboardText) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: _scaffoldKey,
      duration: const Duration(seconds: 5),
      content: Text(
        clipboardText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
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

  void _showCategoryPart2Sheet(List<CategorySingle>? part2List) {
    if (part2List == null || part2List.isEmpty) {
      return;
    }
    if (part2List.length == 1 && part2List[0].categoryPart2.isEmpty) {
      _curCategoryItem.categoryId = part2List[0].categoryId;
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
                      _curCategoryItem.categoryId = part2List[index].categoryId;
                      _curCategoryItem.part2 = part2List[index].categoryPart2;
                    });
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 40,
                      child: Text(part2List[index].categoryPart2)),
                );
              });
        });
  }

  void _showCategoryPart1Sheet(Map<String, List<CategorySingle>> categoryMap) {
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
                      _curCategoryItem.part2 = '';
                      _curCategoryItem.categoryId = -1;
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
    setState(() {
      _onLoading = true;
    });
    CategoryItem categoryItem = _curCategoryItem;

    WishItem wishItem = WishItem()
      ..createdDate = DateTime.now()
      ..modifiedDate = DateTime.now()
      ..name = _nameEditingController.text
      ..price = int.parse(_priceEditingController.text)
      ..url = _urlEditingController.text
      ..category = categoryItem;

    updateRegistry(wishItem);
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

  void updateRegistry(WishItem wishItem) {
    setState(() {
      _onLoading = true;
    });
    FirebaseFirestore.instance
        .collection('registry')
        .where('user.uId', isEqualTo: "HcRzmebMekTFo4w9jm2u")
        .limit(1)
        .get()
        .then((value) {
      value.docs[0].reference.update({
        'wishlist': FieldValue.arrayUnion([wishItem.toJson()])
      }).then((value) {
        setState(() {
          _onLoading = false;
        });
        Navigator.pop(context);
      }, onError: (e) {
        setState(() {
          _onLoading = false;
        });
      });
    }, onError: (e) {
      setState(() {
        _onLoading = false;
      });
    });
  }

  void _parseUrl(String url) {
    MetaParser.getOpenGraphData(url).then((og) {
      setState(() {
        opengraphData = og;
      });
    });
  }

  Widget _buildOgDataCard() {
    return opengraphData == null
        ? Container(
            height: 120,
          )
        : Row(children: [
            SizedBox(
              width: 120,
                height: 120,
                child: Image.network(opengraphData!.image)),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(opengraphData!.title),
          Text(opengraphData!.description)
        ],),
      )
          ]);
  }
}

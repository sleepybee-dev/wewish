import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_category.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/model/item_wish.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/provider/provider_user.dart';
import 'package:wewish/ui/body_common.dart';
import 'package:wewish/ui/button_text_primary.dart';
import 'package:wewish/ui/textfield_common.dart';
import 'package:wewish/util/category_parser.dart';
import 'package:wewish/util/meta_parser.dart';
import 'package:wewish/router.dart' as router;

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

  late UserProvider _userProvider;
  final GlobalKey _scaffoldKey = GlobalKey();

  final CategoryItem _curCategoryItem = CategoryItem();
  Map<String, List<CategorySingle>>? _curCategoryMap;

  OpengraphData? opengraphData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (FirebaseAuth.instance.currentUser == null) {
      _goLoginPage();
    }

    if (widget.url != null) {
      _urlEditingController.text = widget.url!;
      _parseUrl(widget.url!);
    }

    if (widget.url == null && _urlEditingController.text.isEmpty) {
      _doCheckClipboard();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.watch<UserProvider>();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (widget.url == null && _urlEditingController.text.isEmpty) {
        _doCheckClipboard();
      }

      if (widget.url != null) {
        _urlEditingController.text = widget.url!;
        _parseUrl(widget.url!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: CommonBody(
              showBackButton: true,
                onBackPressed: ()=> Navigator.pop(context),
                title: '위시 추가',
                child: _buildBody())));
  }

  Widget _buildBody() {
    return Stack(children: [
      _onLoading
          ? const IgnorePointer(child: Center(child: CircularProgressIndicator()))
          : Container(),
      Column(
        children: [
          _buildOgDataCard(),
          Row(
            children: [
              _buildLabel('url'),
              Expanded(
                  child: CommonTextField(
                controller: _urlEditingController,
                onEditingComplete: () => _parseUrl(_urlEditingController.text),
              ))
            ],
          ),
          Row(
            children: [
              _buildLabel('상품명'),
              Expanded(
                  child: CommonTextField(
                controller: _nameEditingController,
              ))
            ],
          ),
          Row(
            children: [
              _buildLabel('상품가격'),
              Expanded(
                  child: CommonTextField(
                keyboardType: const TextInputType.numberWithOptions(),
                controller: _priceEditingController,
              ))
            ],
          ),
          GestureDetector(
              onTap: _showCategoryBottomSheet,
              child: Container(
                padding: EdgeInsets.only(left:16, right: 16),
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _curCategoryItem.category.isEmpty
                            ? '카테고리 선택'
                            : _curCategoryItem.category, style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Icon(Icons.chevron_right_sharp, color: Theme.of(context).primaryColor,)
                  ],
                ),
              )),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
                onPressed: () => _curCategoryMap != null
                    ? _showCategoryPart1Sheet(_curCategoryMap!)
                    : {},
                child: Text(_curCategoryItem.part1,)),
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
                onPressed: () => _curCategoryMap != null
                    ? _showCategoryPart2Sheet(
                        _curCategoryMap![_curCategoryItem.part1])
                    : {},
                child: Text(_curCategoryItem.part2)),
          ),
          PrimaryTextButton(onPressed: () => _addWish(), label: '위시 추가')
        ],
      ),
    ]);
  }

  void _showCategoryBottomSheet() {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: Category.values.length,
            itemBuilder: (context, index) {
              Category categoryItem = Category.values[index];
              return SizedBox(
                width: double.infinity,
                child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        _curCategoryItem.category = categoryItem.label;
                      });
                      Navigator.pop(context);
                      _fetchCategoryPart(categoryItem);
                    },
                    child: Text(categoryItem.label)),
              );
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
        isDismissible: false,
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
                      height: 48,
                      child: Text(part2List[index].categoryPart2)),
                );
              });
        });
  }

  void _showCategoryPart1Sheet(Map<String, List<CategorySingle>> categoryMap) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
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
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      height: 48,
                      child: Text(keys[index])),
                );
              });
        });
  }

  _addWish() {
    if (!isValidInput()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('입력칸을 채워주세요.')));
      return;
    }

    CategoryItem categoryItem = _curCategoryItem;

    WishItem wishItem = WishItem()
      ..createdDate = DateTime.now()
      ..modifiedDate = DateTime.now()
      ..productName = _nameEditingController.text
      ..price = int.parse(_priceEditingController.text)
      ..url = _urlEditingController.text
      ..category = categoryItem;

    updateRegistry(wishItem);
  }

  void _doCheckClipboard() {
    _fetchClipboardData().then((clipboardText) {
      if (clipboardText != null) {
        _showCopySnackBar(clipboardText);
      }
    });
  }

  void updateRegistry(WishItem wishItem) async {
    setState(() {
      _onLoading = true;
    });
    final registrySnapshot = await FirebaseFirestore.instance
        .collection('registry')
        .where('user.uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get()
        .catchError((error) {
      setState(() {
        _onLoading = false;
      });
    });

    if (registrySnapshot.docs.isEmpty) {
      // 유저가 레지스트리를 만든적이 없어서 유저의 정보를 가져와서 레지스트리에 같이 붙여줘야함.
      final userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .withConverter<UserItem>(
            fromFirestore: (snapshots, _) =>
                UserItem.fromJson(snapshots.data()!),
            toFirestore: (user, _) => user.toJson(),
          )
          .get();

      if (userSnapshot.data() != null) {
        UserItem userItem = userSnapshot.data()!;
        _userProvider.updateLoginUser(userItem);
        FirebaseFirestore.instance.collection('registry').add({
          'user': userItem.toJson(),
          'wishlist': [wishItem.toJson()]
        }).then((value) {
          setState(() {
            _onLoading = false;
          });
          Navigator.pop(context);
        });
      }
    } else {
      await registrySnapshot.docs[0].reference.update({
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
    }
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
            color: Colors.black12,
            height: 120,
            child: const Center(child: Text('미리보기 정보가 존재하지 않습니다.')),
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
                ],
              ),
            )
          ]);
  }

  void _goLoginPage() {
    NavigationProvider navigationProvider = context.watch<NavigationProvider>();
    navigationProvider.updateCurrentTab(MainTab.myPage);
    Navigator.of(context)
        .popAndPushNamed(router.home, arguments: MainTab.myPage);
  }

  bool isValidInput() {
    return _urlEditingController.text.isNotEmpty &&
        _nameEditingController.text.isNotEmpty &&
        _priceEditingController.text.isNotEmpty &&
        _curCategoryItem.categoryId != -1;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _priceEditingController.dispose();
    _urlEditingController.dispose();
    _nameEditingController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SizedBox(width: 80, child: Text(label)),
    );
  }
}

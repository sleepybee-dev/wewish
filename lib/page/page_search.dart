import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/router.dart' as router;
import 'package:wewish/ui/textfield_search.dart';

import '../ui/textfield_common.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late RegistryProvider _registryProvider;
  String _keyword = "";


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registryProvider = Provider.of<RegistryProvider>(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('search'),),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.chevron_left)),
              Expanded(child: SearchTextField(
                  autofocus: true,
                  hintText: '이름을 입력하세요',
                onChanged: (value) {
                  _keyword = value;
                },
                onPressed: () => _doSearch()
              )),
            ],
          ),
          CommonTextField(validationText: '닉네임',), // Test
          Expanded(
              child: Container(
                color: Colors.black12,
                child: ListView.builder(
                  itemCount: _registryProvider.registryList.length,
                    itemBuilder: (context, index) {
                      return _buildListTile(_registryProvider.registryList[index]);
                    }),
              ))
        ],
      ),
    );
  }

  _doSearch() {
    _registryProvider.fetchRegistryList(_keyword);
  }

  @override
  void dispose() {
    _registryProvider.clear();
    super.dispose();
  }

  Widget _buildListTile(RegistryItem registryItem) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: _buildProfile(registryItem.user),
          trailing: Text(registryItem.wishList.length.toString()),
          onTap: () => _goRegistryPage(registryItem),
        ),
      ),
    );
  }

  _goRegistryPage(RegistryItem registryItem) {
    Navigator.pushNamed(context, router.wishlistPage, arguments: registryItem);
  }

  Widget _buildProfile(UserItem user) {
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
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.nickname),
                Row(
                  children: [
                    _buildHashTagText(user.hashTag[0]),
                    _buildHashTagText(user.hashTag[1]),
                    _buildHashTagText(user.hashTag[2]),
                  ],
                ),

              ],
            ))
      ],
    );
  }

  _buildHashTagText(String hashtag) {
   return Text('#$hashtag', style: const TextStyle(fontSize: 13,));
  }
}

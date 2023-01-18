import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wewish/constants.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/router.dart' as router;
import 'package:wewish/ui/card_profile.dart';
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
      body: Column(
        children: [
          Row(
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.chevron_left)),
              Expanded(child: SearchTextField(
                  autofocus: false,
                  hintText: '이름을 입력하세요',
                onChanged: (value) {
                  _keyword = value;
                },
                onPressed: () => _doSearch()
              )),
            ],
          ),
          Expanded(
              child: ListView.builder(
                itemCount: _registryProvider.registryList.length,
                  itemBuilder: (context, index) {
                    return _buildListTile(_registryProvider.registryList[index]);
                  }))
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
          title: ProfileCard(registryItem.user),
          trailing: Text(registryItem.wishList.length.toString()),
          onTap: () => _goRegistryPage(registryItem),
        ),
      ),
    );
  }

  _goRegistryPage(RegistryItem registryItem) {
    Navigator.pushNamed(context, router.wishlistPage, arguments: registryItem);
  }

}

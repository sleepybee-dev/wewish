import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/model/item_user.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/router.dart' as router;

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
              Expanded(child: TextField(
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                onChanged: (value) {
                  _keyword = value;
                },
              )),
              IconButton(onPressed: () => _doSearch(), icon: const Icon(Icons.search))
            ],
          ),
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
                Row(
                  children: [
                    Text(user.nickname),
                    Text("("+"id"+")"), // firebase에서 가져올 것
                  ],
                ),
                Row(
                  children: [
                    Text("#"+user.hashTag[0], style: TextStyle(fontSize: 13,)),
                    Text("#"+user.hashTag[1], style: TextStyle(fontSize: 13,)),
                    Text("#"+user.hashTag[2], style: TextStyle(fontSize: 13,))
                  ],
                ),

              ],
            ))
      ],
    );
  }
}

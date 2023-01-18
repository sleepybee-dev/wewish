import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/ui/textfield_search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:120, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('누구의 위시리스트를\n보고 싶으신가요?', style: Theme.of(context).textTheme.headlineMedium),
              Padding(
                padding: const EdgeInsets.only(top:40.0),
                child: GestureDetector(
                  onTap: () => goSearchPage(),
                  child: SearchTextField(
                    enabled: false,
                    onPressed: () {  },)
                  ),
              ),
            ],
          ),
        ));
  }

  goSearchPage() {
    Provider.of<NavigationProvider>(context, listen: false)
        .updateCurrentTab(MainTab.search);
  }
}

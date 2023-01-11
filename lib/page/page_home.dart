import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(
      child: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('이름을 검색하여\n다른 사람들의 위시리스트를\n확인할 수 있어요',
                textAlign: TextAlign.center,
                style:TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: GestureDetector(
                  onTap: () => goSearchPage(),
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
                        Spacer(),
                      ],
                    ),
                    decoration : BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.3),
                      blurRadius: 5, offset: const Offset(0,3),
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.grey[300],
                    ),
                  ),
              ),
            ),
        ],
        ),
      ),
    ));
  }

  goSearchPage() {
    Provider.of<NavigationProvider>(context, listen: false).updateCurrentPage(0);
  }

}

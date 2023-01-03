import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wewish/firebase_options.dart';
import 'package:wewish/home.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/router.dart' as router;

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => RegistryProvider())
      ],
      child: MaterialApp(
          title: 'WeWish',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: router.generateRoute,
          initialRoute: router.home,
          home: LayoutBuilder(builder: (context, constraints) {
            if (kIsWeb) {
              if (constraints.maxWidth >= 1200) {
                return _buildThreeColumnHome();
              // } else if (constraints.maxWidth >= 768) {
              //   return _buildTwoColumnHome() ;
              } else {
                return Home();
              }
            } else {
              return Home();
            }
          })
      ),
    );
  }

  Widget _buildThreeColumnHome() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.amber,
          ),
        ),
        SizedBox(
          width: 1200,
          child: Home(),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.amber,
          ),
        )
      ],
    );
  }

  Widget _buildTwoColumnHome() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.amber,
          ),
        ),
        SizedBox(
          width: 768,
          child: Home(),
        )
      ],
    );
  }
}

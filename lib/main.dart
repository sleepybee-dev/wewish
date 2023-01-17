import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:wewish/firebase_options.dart';
import 'package:wewish/home.dart';
import 'package:wewish/provider/provider_bottom_nav.dart';
import 'package:wewish/provider/provider_registry.dart';
import 'package:wewish/provider/provider_user.dart';
import 'package:wewish/router.dart' as router;

void main() async {
  KakaoSdk.init(nativeAppKey: 'fd06fc462ea9be9e6ccbb2cc0a121309');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => NavigationProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => RegistryProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => UserProvider()),
      ],
      child: MaterialApp(
          title: 'WeWish',
          theme: _wewishTheme,
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
          })),
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

  final _wewishTheme = ThemeData(
    fontFamily: 'AppleSDGothicNeo',
    // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF90DFF9)),
    primarySwatch: const MaterialColor(0xFF90DFF9, {
      50: Color(0xffe5f4fd),
      100: Color(0xffbee3fa),
      200: Color(0xff97d2f8),
      300: Color(0xff6fbff5),
      400: Color(0xff50b1f4),
      500: Color(0xff2fa4f4),
      600: Color(0xff2796e7),
      700: Color(0xff1c84d4),
      800: Color(0xff1273c3),
      900: Color(0xff0055a6),
    }),
  );
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:salon/AuthPages/authentication.dart';
import 'package:salon/home.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_dc72c1b8777945a692dc2cdb08175a56",
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const AuthPage(),
          routes: {
            'home': (context) => HomePage(),
            'authPage': (context) => const AuthPage(),
          },
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
        );
      },
    );
  }
}
